package com.yingu.project.audit.web.service.impl;

import com.google.common.collect.Sets;
import com.yingu.project.audit.Status;
import com.yingu.project.audit.api.GeneralResponse;
import com.yingu.project.audit.module.User;
import com.yingu.project.audit.persistence.entity.RoleEntity;
import com.yingu.project.audit.persistence.entity.UserEntity;
import com.yingu.project.audit.persistence.repository.UserRepository;
import com.yingu.project.audit.web.service.UserService;
import com.yingu.project.audit.web.utils.StringUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.crypto.hash.Sha256Hash;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

/**
 * Created by Administrator on 2017/1/13.
 */
@Service
@Slf4j
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository repository;


    @Override
    public GeneralResponse<User> createUser(String userName, String password) {
        GeneralResponse<User> response = new GeneralResponse<>();
        try {
            if (repository.findByUsername(userName) != null) {
                response.setStatus(Status.FAILED);
                response.setMessage("User name already exist");
            } else {
                UserEntity user = new UserEntity(userName, password);
                String salt1 = new Date().toString();
                user.setPassword(new Sha256Hash(password, salt1).toBase64());
                user.setSalt(salt1);
                repository.saveAndFlush(user);
                response.setStatus(Status.SUCCESS);
            }
        } catch (Exception e) {
            log.error("error", e);
            response.setStatus(Status.FAILED);
            response.setMessage(e.getMessage());
        }
        return response;
    }


    @Override
    public Set<String> findRoles(String username) {
        UserEntity userEntity = repository.findByUsername(username);
        Set<String> roles = Sets.newHashSet();
        if (userEntity != null) {
            userEntity.getRoles().stream().forEach(roleEntity -> roles.add(roleEntity.getRole()));
        }
        return roles;
    }

    @Override
    public Set<String> findPermissions(String username) {
        UserEntity userEntity = repository.findByUsername(username);
        Set<String> result = Sets.newHashSet();
        if (userEntity != null) {
            List<RoleEntity> roles = userEntity.getRoles();
            if (roles != null) {
                roles.stream().forEach(roleEntity -> roleEntity.getResources().stream().forEach(resourceEntity ->
                        result.add(resourceEntity.getUrl())));

            }
        }
        return result;
    }

    @Override
    public UserEntity findByUsername(String userName) {
        return repository.findByUsername(userName);
    }


    @Override
    public GeneralResponse<User> batchDelStatus(Boolean status, String ids) {
        GeneralResponse<User> response = new GeneralResponse<>();
        try {
            if (!StringUtil.format(ids).equals("")) {
                String[] item = ids.split(",");
                List<UserEntity> listItem = new ArrayList<>();
                for (String id : item) {
                    UserEntity u = repository.findOne(Long.parseLong(id));
                    if (u.getUsername().equals("administrator")) {
                        continue;
                    }
                    listItem.add(u);
                }
                repository.deleteInBatch(listItem);
                response.setStatus(Status.SUCCESS);
                response.setMessage(listItem.size() + " records deleted");
            }
        } catch (Exception e) {
            log.error("error", e);
            response.setStatus(Status.FAILED);
            response.setMessage(e.getMessage());
        }
        return response;
    }

    @Override
    public GeneralResponse<User> changePassword(Long userId, String newPassword) {
        GeneralResponse<User> response = new GeneralResponse<>();
        try {
            UserEntity u = repository.findOne(userId);
            u.setPassword(new Sha256Hash(newPassword, u.getSalt()).toBase64());
            repository.save(u);
            response.setStatus(Status.SUCCESS);
        } catch (Exception e) {
            log.error("error", e);
            response.setStatus(Status.FAILED);
            response.setMessage(e.getMessage());
        }
        return response;
    }


    @Override
    public GeneralResponse<User> getAllUsers(int currentPage, int pageSize) {
        GeneralResponse<User> response = new GeneralResponse<>();
        try {
            if (currentPage == 0) {
                currentPage = 1;
            }
            Sort sort = new Sort(Sort.Direction.DESC, "id");
            Pageable pageable = new PageRequest(currentPage - 1, pageSize, sort);
            Page<UserEntity> page = repository.findAll(new Specification<UserEntity>() {
                @Override
                public Predicate toPredicate(Root<UserEntity> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
                    Predicate isDelete = null;
                    isDelete = cb.equal(root.<Boolean>get("deleted"), false);
                    query.where(isDelete);
                    return null;
                }
            }, pageable);
            putEntity(page.getContent(), response);
            response.setCurrentPage(currentPage);
            response.setTotalPage(page.getTotalPages());
            response.setTotalSize(page.getTotalElements());
            response.setStatus(Status.SUCCESS);
        } catch (Exception e) {
            log.error("error", e);
            response.setStatus(Status.FAILED);
            response.setMessage(e.getMessage());
        }
        return response;
    }

    private void putEntity(List<UserEntity> dataList, GeneralResponse<User> response) {
        List<User> orgCodeList = new ArrayList<>();
        if (dataList != null && dataList.size() > 0) {
            for (UserEntity orgCodeEntity : dataList) {
                User user = new User();
                BeanUtils.copyProperties(orgCodeEntity, user);
                orgCodeList.add(user);
            }
        }
        response.setData(orgCodeList);
    }

}
