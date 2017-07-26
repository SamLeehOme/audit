package com.yingu.project.audit.web.service;


import com.yingu.project.audit.api.GeneralResponse;
import com.yingu.project.audit.module.User;
import com.yingu.project.audit.persistence.entity.UserEntity;

import java.util.Set;

/**
 * Created by Administrator on 2016/12/30.
 */
public interface UserService {

    GeneralResponse<User> createUser(String userName, String password);

    GeneralResponse<User> getAllUsers(int currentPage, int pageSize);

    GeneralResponse<User> batchDelStatus(Boolean status, String ids);

    GeneralResponse<User> changePassword(Long userId, String newPassword);

    Set<String> findRoles(String username);

    Set<String> findPermissions(String username);

    UserEntity findByUsername(String userName);
}
