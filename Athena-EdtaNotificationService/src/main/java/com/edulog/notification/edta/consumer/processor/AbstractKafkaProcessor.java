package com.edulog.notification.edta.consumer.processor;

import java.util.List;
import org.apache.kafka.clients.consumer.ConsumerRecord;

public abstract class AbstractKafkaProcessor<T> extends AbstractProcessor<T> {

    @Override
    public void processEvent(List<ConsumerRecord<String, String>> events) {
        events.forEach(this::processKafkaEvent);
    }
}
