package com.edulog.notification.edta.consumer;

import java.util.List;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.annotation.KafkaListener;
import com.edulog.notification.edta.consumer.processor.GeneralNotificationProcessor;

@EnableKafka
@Configuration
public class KafkaConsumer {

    @Autowired
    private GeneralNotificationProcessor generalNotificationProcessor;

    @KafkaListener(clientIdPrefix = "#{'${kafka.consumer-group}-' + T(java.util.UUID).randomUUID()}",
            topics = "#{'${kafka.consumer.edtaGeneral}'}", containerFactory = "eventsFactory")
    public void receiveForInsert(List<ConsumerRecord<String, String>> data) {
        generalNotificationProcessor.processEvent(data);
    }
}
