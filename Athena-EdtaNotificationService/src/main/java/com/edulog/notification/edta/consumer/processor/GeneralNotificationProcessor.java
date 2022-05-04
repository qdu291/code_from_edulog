package com.edulog.notification.edta.consumer.processor;

import java.io.IOException;
import java.util.Arrays;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;
import com.edulog.notification.edta.model.Notification;
import com.edulog.notification.edta.mqtt.AWSThingConnection;

@Service
public class GeneralNotificationProcessor extends AbstractKafkaProcessor<Notification> {

    @Value("${channels.general}")
    private String generalChannel;

    @Autowired
    private AWSThingConnection awsThingConnection;

    @Override
    protected void processEvent(Notification notification) throws InterruptedException, IOException {
        String tenantId = notification.getTenantId();
        String eventId = notification.getEventId();
        Assert.notNull(tenantId, "tenantId must not be null");
        Assert.notNull(eventId, "eventId must not be null");
        Assert.notNull(generalChannel, "generalChannel must not be null");
        String channel = StringUtils.join(Arrays.asList(generalChannel, eventId, tenantId), '/');
        awsThingConnection.publishMessage(channel, notification);
    }
}
