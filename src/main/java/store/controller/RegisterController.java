package store.controller;

import store.bean.User;
import store.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class RegisterController {

    @Autowired
    private UserService userService;

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(
            @RequestParam String yhm,
            @RequestParam String yhxm,
            @RequestParam String mm,
            Model model) {

        // 检查用户名是否存在
        if (userService.isUsernameExist(yhm)) {
            model.addAttribute("error", "用户名已存在");
            model.addAttribute("yhm", yhm);
            model.addAttribute("yhxm", yhxm);
            return "register";
        }

        // 验证密码长度
        if (mm.length() < 6) {
            model.addAttribute("error", "密码长度不能少于6位");
            model.addAttribute("yhm", yhm);
            model.addAttribute("yhxm", yhxm);
            return "register";
        }

        // 创建用户对象
        User user = new User();
        user.setUsername(yhm);
        user.setRealName(yhxm);
        user.setPassword(mm);
        user.setStatus(0); // 0表示正常状态

        // 保存用户
        int result = userService.addUser(user);
        if (result > 0) {
            return "redirect:/login?registerSuccess=true";
        } else {
            model.addAttribute("error", "注册失败，请稍后再试");
            return "register";
        }
    }

    @GetMapping("/checkUsername")
    @ResponseBody
    public String checkUsername(@RequestParam String username) {
        return userService.isUsernameExist(username) ? "exist" : "available";
    }
}