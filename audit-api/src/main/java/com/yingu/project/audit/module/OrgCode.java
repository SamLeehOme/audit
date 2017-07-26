package com.yingu.project.audit.module;

import lombok.*;

/**
 * Created by admi on 2016/11/9.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class OrgCode {
    private long id;
    private String code;
    private String name;
    private String dateCreated;
    private String lastModified;
}

