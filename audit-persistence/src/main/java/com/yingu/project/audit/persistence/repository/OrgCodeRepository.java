package com.yingu.project.audit.persistence.repository;

import com.yingu.project.audit.persistence.entity.OrgCodeEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by Administrator on 2016/11/17.
 */
@Repository
public interface OrgCodeRepository extends JpaRepository<OrgCodeEntity, Long> {

    OrgCodeEntity findByCode(String code);

    OrgCodeEntity findByName(String name);
}
