package com.yingu.project.audit.persistence.repository;

import com.yingu.project.audit.persistence.entity.ResourceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

/**
 * Created by Administrator on 2017/3/7.
 */
@Repository
public interface PermissionRepository extends JpaRepository<ResourceEntity, Long>,JpaSpecificationExecutor<ResourceEntity> {
}
