package com.edulog.notification.edta.mqtt;

import com.amazonaws.services.iot.client.AWSIotMqttClient;

public interface AWSThingConnection {

    void createConnection();

    void publishMessage(String topic, Object data);

    AWSIotMqttClient getMqttClientConnection();
}
