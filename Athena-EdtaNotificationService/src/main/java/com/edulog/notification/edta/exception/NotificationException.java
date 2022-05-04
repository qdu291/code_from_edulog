package com.edulog.notification.edta.exception;

public class NotificationException extends RuntimeException {
    private static final long serialVersionUID = -2876762918109757227L;

    public NotificationException(String message) {
        super(message);
    }

    public NotificationException(String message, Throwable cause) {
        super(message, cause);
    }

    public NotificationException(Throwable cause) {
        super(cause);
    }
}
