package store.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {
    
    @GetMapping("/")
    public String index() {
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