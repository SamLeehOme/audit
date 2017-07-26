package com.yingu.project.audit.web.controller;

import com.yingu.project.audit.web.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by Administrator on 2017/2/13.
 */
@RestController
@RequestMapping(value = "user")
public class UserController extends BaseController{
    @Autowired
    private UserService service;

    @RequestMapping(value = "getAllUser",method = RequestMethod.GET)
    public void getAllUsers(@RequestParam int currentPage, @RequestParam int pageSize){
        ajaxOut(service.getAllUsers(currentPage,pageSize));
    }

    @RequestMapping(value="addUser",method = RequestMethod.POST)
    public void addUser(@RequestParam String username, @RequestParam String password) {
        ajaxOut(service.createUser(username, password));
    }

    @RequestMapping(value="changePassword",method = RequestMethod.POST)
    public void changePassword(@RequestParam String id, @RequestParam String password) {
        ajaxOut(service.changePassword(Long.parseLong(id), password));
    }

    @RequestMapping(value="delUsers",method = RequestMethod.POST)
    public void delUsers(@RequestParam String ids){
        ajaxOut(service.batchDelStatus(true, ids));
    }
}

