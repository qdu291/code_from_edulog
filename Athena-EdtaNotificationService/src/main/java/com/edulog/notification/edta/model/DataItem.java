package com.edulog.notification.edta.model;

import java.io.Serializable;
import java.util.List;
import lombok.Data;

@Data
public class DataItem implements Serializable {

    private static final long serialVersionUID = -8005057380398090727L;
    private String key;
    private String value;
    private List<DataItem> children;
}
