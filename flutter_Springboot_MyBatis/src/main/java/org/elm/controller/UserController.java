package org.elm.controller;

import jakarta.annotation.Resource;
import org.elm.Service.IUserService;
import org.elm.domin.User;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Base64;

@RestController
@RequestMapping("/UserController")
@CrossOrigin(allowedHeaders = {"*"})

public class UserController {
    @Resource
    private IUserService userService;
    @GetMapping("/getUserByIdAndPassword")
    public User getUserByIdByPass(String userId,String password) throws Exception{
        return userService.getUserByIdAndPassword(userId,password);
    }
    @GetMapping("/getUserById")
    public User getUserById(String userId) throws Exception{
        return userService.getUserById(userId);
    }
    @PostMapping("/saveUser")
    public int saveUser(User user) throws Exception{
        return userService.saveUser(user);
    }
    @GetMapping("/getImage")
    public void getImage(){

    }
    @PutMapping("updateUser")
    public int updateUser(@RequestBody User user)throws  Exception{
       return userService.updateUser(user);
    }

}
