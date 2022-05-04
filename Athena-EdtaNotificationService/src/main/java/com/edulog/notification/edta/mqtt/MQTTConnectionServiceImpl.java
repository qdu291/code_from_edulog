package com.edulog.notification.edta.mqtt;

import java.util.UUID;
import javax.annotation.PostConstruct;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.amazonaws.services.iot.client.AWSIotMessage;
import com.amazonaws.services.iot.client.AWSIotMqttClient;
import com.amazonaws.services.iot.client.AWSIotQos;
import com.edulog.notification.edta.common.JsonUtil;

@Service
public class MQTTConnectionServiceImpl implements AWSThingConnection {

    private static final Logger logger = LoggerFactory.getLogger(MQTTConnectionServiceImpl.class);

    private static final AWSIotQos testTopicQos = AWSIotQos.QOS0;

    private AWSIotMqttClient clientConnection;

    @Value("${mqtt.certificateFile}")
    private String certFile;

    @Value("${mqtt.privateKeyFile}")
    private String privateKeyFile;

    @Value("${mqtt.endPoint}")
    private String endPoint;

    @Override
    @PostConstruct
    public void createConnection() {
        try {
            String clientId = UUID.randomUUID().toString();
            clientConnection = initClient(certFile, privateKeyFile, endPoint, clientId, clientConnection);
            clientConnection.setKeepAliveInterval(5);
            clientConnection.setConnectionTimeout(10);
            clientConnection.setCleanSession(true);
            clientConnection.connect();
        } catch (Exception e) {
            logger.error("=== MQTT ERROR === Create connection error!", e);
        }
    }

    private AWSIotMqttClient initClient(String certFile, String privateKeyFile, String endPoint, String clientId,
            AWSIotMqttClient awsIotClient) {

        if (awsIotClient == null && certFile != null && privateKeyFile != null) {
            MQTTConnectionUtility.KeyStorePasswordPair pair = MQTTConnectionUtility.getKeyStorePasswordPair(certFile, privateKeyFile);
            awsIotClient = new AWSIotMqttClient(endPoint, clientId, pair.keyStore, pair.keyPassword);
        }

        if (awsIotClient == null) {
            String awsAccessKeyId = MQTTConnectionUtility.getConfig("awsAccessKeyId");
            String awsSecretAccessKey = MQTTConnectionUtility.getConfig("awsSecretAccessKey");
            String sessionToken = MQTTConnectionUtility.getConfig("sessionToken");

            if (awsAccessKeyId != null && awsSecretAccessKey != null) {
                awsIotClient = new AWSIotMqttClient(endPoint, clientId, awsAccessKeyId, awsSecretAccessKey, sessionToken);
            }
        }

        if (awsIotClient == null) {
            throw new IllegalArgumentException("Failed to construct client due to missing certificate or credentials.");
        }

        return awsIotClient;
    }

    @Override
    public void publishMessage(String topic, Object data) {
        try {
            String json = JsonUtil.toJson(data).orElse(StringUtils.EMPTY);
            AWSIotMessage message = new NonBlockingPublishListener(topic, testTopicQos, json);
            this.clientConnection.publish(message);
            logger.info("MQTT Publish message successfully, topic=[{}], data=[{}].", topic, json);
        } catch (Exception e) {
            logger.error("MQTT Publish message error! ", e);
        }
    }

    @Override
    public AWSIotMqttClient getMqttClientConnection() {
        return clientConnection;
    }
}
