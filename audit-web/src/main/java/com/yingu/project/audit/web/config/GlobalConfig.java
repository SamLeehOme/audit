package com.yingu.project.audit.web.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Created by admi on 2016/11/7.
 */
@ConfigurationProperties(prefix = "global-config")
@Getter
@Setter
public class GlobalConfig {
    private String serverUrl;
}
