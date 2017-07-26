package com.yingu.project.audit.module;

import lombok.*;

/**
 * Created by asus on 7/22/2017.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class User {
    private String username;
    private String password;
    private String salt = "";
    private Boolean locked = Boolean.FALSE;
}
