package com.edulog.notification.edta;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@Configuration
@EnableAsync
@EnableEurekaClient
public class EdtaNotificationApplication {
    public static void main(String[] args) {
        SpringApplication.run(EdtaNotificationApplication.class, args);
    }
}
