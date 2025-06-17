package com.zmazon.cloudraiseruseast1.cloudraisereks.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
/**
 * @Author LeeLeven
 * @Date 2025/5/28
 * @Description
 * @Version 2.0
 */
@Controller
public class WelcomeController {

    @GetMapping("/")
    public String welcome(Model model) {
        model.addAttribute("message", "欢迎");
        return "welcome";
    }
}