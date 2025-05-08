package store.controller;

import store.bean.User;
import store.service.UserService;
import store.util.CaptchaUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;
    private static final int SHOW_CAPTCHA_AFTER = 3;
    private static final int LOCK_AFTER = 6;
    // 存储登录尝试次数
    private static final Map<String, Integer> loginAttempts = new HashMap<>();

    @GetMapping("/login")
    public String loginPage(HttpServletRequest request, Model model) {
        String username = request.getParameter("username");
        if (username != null) {
            model.addAttribute("username", username);
        }
        return "login";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam(required = false) String captcha,
            HttpSession session,
            Model model) {

        // 先检查用户名是否存在
        if (!userService.isUsernameExist(username)) {
            model.addAttribute("error", "用户名不存在");
            model.addAttribute("username", username);
            return "login";
        }

        // 检查用户是否被锁定
        User userCheck = userService.getUserByUsername(username);
        if (userCheck != null && "1".equals(userCheck.getStatus())) {
            model.addAttribute("error", "您的账户已被锁定，请联系管理员解锁");
            model.addAttribute("username", username);
            return "login";
        }

        // 检查验证码
        boolean showCaptcha = loginAttempts.containsKey(username) && loginAttempts.get(username) >= 3;
        if (showCaptcha) {
            String sessionCaptcha = (String) session.getAttribute("captcha");
            if (sessionCaptcha == null || !sessionCaptcha.equalsIgnoreCase(captcha)) {
                // 增加尝试次数
                int attempts = loginAttempts.getOrDefault(username, 0) + 1;
                loginAttempts.put(username, attempts);
                int remaining = 6 - attempts;

                if (attempts >= 6) {
                    // 锁定用户
                    userService.lockUser(username);
                    model.addAttribute("error", "您已连续6次登录失败，账户已被锁定，请联系管理员解锁");
                } else {
                    model.addAttribute("error", "验证码错误，您还有" + remaining + "次尝试机会");
                }

                model.addAttribute("username", username);
                model.addAttribute("showCaptcha", true);
                return "login";
            }
        }

        User user = userService.login(username, password);
        if (user == null) {
            // 增加尝试次数
            int attempts = loginAttempts.getOrDefault(username, 0) + 1;
            loginAttempts.put(username, attempts);
            int remaining = 6 - attempts;

            if (attempts >= 6) {
                // 锁定用户
                userService.lockUser(username);
                model.addAttribute("error", "您已连续6次登录失败，账户已被锁定，请联系管理员解锁");
            } else if (attempts >= 3) {
                model.addAttribute("error", "用户名或密码错误，您还有" + remaining + "次尝试机会");
                model.addAttribute("showCaptcha", true);
            } else {
                model.addAttribute("error", "用户名或密码错误，您还有" + remaining + "次尝试机会");
            }

            model.addAttribute("username", username);
            return "login";
        }

        // 登录成功，重置尝试次数
        loginAttempts.remove(username);
        session.setAttribute("currentUser", user);
        return "redirect:/index";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("currentUser");
        return "redirect:/login";
    }

    @GetMapping("/captcha")
    public void captcha(HttpSession session, HttpServletResponse response) throws IOException {
        // 设置响应类型为图片
        response.setContentType("image/jpeg");
        // 禁止缓存
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        try (OutputStream output = response.getOutputStream()) {
            // 生成验证码并写入响应
            String captcha = CaptchaUtil.generateCaptcha(output);
            // 将验证码存入session
            session.setAttribute("captcha", captcha);
        }
    }
}
