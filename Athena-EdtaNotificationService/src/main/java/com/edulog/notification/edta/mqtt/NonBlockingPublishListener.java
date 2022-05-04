package com.edulog.notification.edta.mqtt;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.amazonaws.services.iot.client.AWSIotMessage;
import com.amazonaws.services.iot.client.AWSIotQos;

public class NonBlockingPublishListener extends AWSIotMessage {

    private static final Logger logger = LoggerFactory.getLogger(NonBlockingPublishListener.class);

    public NonBlockingPublishListener(String topic, AWSIotQos qos, String payload) {
        super(topic, qos, payload);
    }

    @Override
    public void onSuccess() {
        logger.info("{} : >>> {}", System.currentTimeMillis(), getStringPayload());
    }

    @Override
    public void onFailure() {
        logger.error("{} : publish failed for {}", System.currentTimeMillis(), getStringPayload());
    }

    @Override
    public void onTimeout() {
        logger.error("{} : publish timeout for {}", System.currentTimeMillis(), getStringPayload());
    }

}
