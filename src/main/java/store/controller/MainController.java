package store.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import javax.servlet.http.HttpSession;

@Controller
public class MainController {

    @GetMapping("/index")
    public String index(HttpSession session) {
        // 检查用户是否登录，未登录则重定向到登录页面
        if (session.getAttribute("currentUser") == null) {
            return "redirect:/login";
        }
        return "index";
    }

    @GetMapping("/top")
    public String top() {
        return "top";
    }

    @GetMapping("/left")
    public String left() {
        return "left";
    }

    @GetMapping("/mainfra")
    public String mainfra() {
        return "mainfra";
    }
}