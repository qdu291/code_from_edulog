package com.edulog.notification.edta.producer;

import java.util.concurrent.ExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;
import com.edulog.notification.edta.exception.NotificationException;

@Component
public class KafkaProducer {

    private static Logger log = LoggerFactory.getLogger(KafkaProducer.class);

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    public void send(String topic, String data) {
        try {
            log.info("Sending ({}) to {}...", data, topic);
            SendResult<String, String> result = kafkaTemplate.send(topic, data).get();
            String returnedTopic = result.getRecordMetadata().topic();
            int returnedPartition = result.getRecordMetadata().partition();
            long returnedOffset = result.getRecordMetadata().offset();
            log.info("Topic = {}, Partition = {}, Offset = {}", returnedTopic, returnedPartition, returnedOffset);
        } catch (InterruptedException | ExecutionException e) {
            log.error("Execution Exception Sending Record", e);
            throw new NotificationException("Sending record got error: ", e);
        }
    }
}
