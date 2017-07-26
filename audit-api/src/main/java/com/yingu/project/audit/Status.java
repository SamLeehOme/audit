package com.yingu.project.audit;

public enum Status {

    SUCCESS,
    FAILED
    ;

    public String value() {
        return name();
    }

    public static Status fromValue(String v) {
        return valueOf(v);
    }
}