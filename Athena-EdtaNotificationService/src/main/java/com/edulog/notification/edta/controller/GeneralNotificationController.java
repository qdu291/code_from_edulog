package com.edulog.notification.edta.controller;

import java.util.concurrent.ExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.edulog.notification.edta.common.JsonUtil;
import com.edulog.notification.edta.exception.NotificationException;
import com.edulog.notification.edta.model.Notification;

@RestController
@RequestMapping({"/api/v1/edtanotification/general"})
public class GeneralNotificationController {

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Value("${kafka.producer.edtaGeneral}")
    private String topic;

    @PostMapping(value = "/send", consumes = "application/json", produces = "application/json")
    public void sendMessage(@RequestBody Notification message) {
        try {
            kafkaTemplate.send(topic, JsonUtil.toJson(message).orElse(null)).get();
        } catch (InterruptedException | ExecutionException e) {
            throw new NotificationException("Sending message got error", e);
        }
    }
}
