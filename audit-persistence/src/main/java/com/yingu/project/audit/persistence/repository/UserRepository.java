package com.yingu.project.audit.persistence.repository;

import com.yingu.project.audit.persistence.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by Administrator on 2017/3/7.
 */
@Repository
public interface UserRepository extends JpaRepository<UserEntity, Long>,JpaSpecificationExecutor<UserEntity> {
    @Transactional
    UserEntity findByUsername(String userName);
}
