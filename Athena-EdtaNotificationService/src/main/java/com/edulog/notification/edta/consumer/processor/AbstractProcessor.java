package com.edulog.notification.edta.consumer.processor;

import java.io.IOException;
import java.lang.reflect.ParameterizedType;
import java.util.List;
import java.util.Optional;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import com.edulog.notification.edta.common.JsonUtil;

public abstract class AbstractProcessor<T> {

    final Log logger = LogFactory.getLog(this.getClass());

    protected abstract void processEvent(List<ConsumerRecord<String, String>> events);

    protected abstract void processEvent(T eventModel) throws InterruptedException, IOException;

    @SuppressWarnings("unchecked")
    protected Class<T> getGenericTypeClass() {
        try {
            String className = ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0].getTypeName();
            Class<?> clazz = Class.forName(className);
            return (Class<T>) clazz;
        } catch (Exception e) {
            logger.error(e);
            throw new IllegalStateException("Class is not parametrized with generic type!!! Please use extends <> ");
        }
    }

    protected void processKafkaEvent(ConsumerRecord<String, String> event) {
        try {
            logger.info("Kafka message: " + event.value());
            Optional<T> eventOpt = JsonUtil.toObject(event.value(), getGenericTypeClass());
            if (eventOpt.isPresent()) {
                processEvent(eventOpt.get());
            }

        } catch (Exception e) {
            logger.error("Exception when sent message", e);
        }
    }

}
