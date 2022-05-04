package com.edulog.notification.edta.model;

import java.io.Serializable;
import java.util.List;
import lombok.Data;

@Data
public class Notification implements Serializable {

    private static final long serialVersionUID = 2090865935620782298L;
    private String eventId;
    private String tenantId;
    private List<DataItem> dataItems;
}
