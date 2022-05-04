package com.edulog.notification.edta.common;

import java.io.IOException;
import java.util.Objects;
import java.util.Optional;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

public class JsonUtil {

    private static final Logger LOG = LoggerFactory.getLogger(JsonUtil.class);
    private static ObjectMapper objectMapper;

    static {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        objectMapper.configure(DeserializationFeature.READ_UNKNOWN_ENUM_VALUES_AS_NULL, true);
        objectMapper.configure(SerializationFeature.WRAP_ROOT_VALUE, false);
    }

    private JsonUtil() {}

    public static <T> Optional<T> toObject(String data, Class<T> clazz) {
        if (StringUtils.isEmpty(data) || Objects.isNull(clazz)) {
            return Optional.empty();
        }
        try {
            return Optional.of(objectMapper.readValue(data, clazz));
        } catch (IOException e) {
            LOG.error(e.getMessage(), e);
            return Optional.empty();
        }
    }

    public static Optional<String> toJson(Object data) {
        if (Objects.isNull(data)) {
            return Optional.empty();
        }
        try {
            return Optional.of(objectMapper.writeValueAsString(data));
        } catch (JsonProcessingException e) {
            LOG.error(e.getMessage(), e);
            return Optional.empty();
        }
    }
}
