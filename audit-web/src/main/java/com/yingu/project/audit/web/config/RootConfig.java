package com.yingu.project.audit.web.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * Created by Administrator on 2016/8/11.
 */
@Configuration
@ComponentScan(basePackages = {"com.yingu.project.audit.web.service"})
public class RootConfig {
}
