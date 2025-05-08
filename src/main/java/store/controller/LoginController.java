package store.controller;

import store.bean.User;
import store.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

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
        
        // 检查用户是否被锁定
        if (loginAttempts.containsKey(username) && loginAttempts.get(username) >= 6) {
            model.addAttribute("error", "您的账户已被锁定，请联系管理员解锁");
            return "login";
        }

        // 检查验证码
        boolean showCaptcha = loginAttempts.containsKey(username) && loginAttempts.get(username) >= 3;
        if (showCaptcha) {
            String sessionCaptcha = (String) session.getAttribute("captcha");
            if (sessionCaptcha == null || !sessionCaptcha.equalsIgnoreCase(captcha)) {
                model.addAttribute("error", "验证码错误");
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
            
            if (attempts >= 6) {
                // 锁定用户
                userService.lockUser(username);
                model.addAttribute("error", "您已连续6次登录失败，账户已被锁定，请联系管理员解锁");
            } else if (attempts >= 3) {
                model.addAttribute("error", "用户名或密码错误，您还有" + (6 - attempts) + "次尝试机会");
                model.addAttribute("showCaptcha", true);
            } else {
                model.addAttribute("error", "用户名或密码错误，您还有" + (6 - attempts) + "次尝试机会");
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
    public String captcha(HttpSession session) {
        // 生成验证码逻辑
        String captcha = generateRandomCaptcha();
        session.setAttribute("captcha", captcha);
        // 这里应该返回验证码图片，简化示例
        return "captcha"; // 实际应该返回图片响应
    }

    private String generateRandomCaptcha() {
        // 简单实现，实际应该生成图片验证码
        return String.valueOf((int)(Math.random() * 9000) + 1000);
    }
}