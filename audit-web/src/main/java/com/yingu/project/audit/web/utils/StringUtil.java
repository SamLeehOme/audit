package com.yingu.project.audit.web.utils;

/**
 * Created by user on 2017/3/10.
 */
public class StringUtil {
    public static int size(String str) {
        if (isEmpty(str))
            return 0;
        else
            return str.length();
    }

    public static boolean isEmpty(String value) {
        if (value == null || value.trim().length() == 0)
            return true;
        else
            return false;
    }

    public static String format(String value) {
        return format(value, "");
    }

    public static String format(String value, String defaultValue) {
        if (isEmpty(value))
            return defaultValue;
        else
            return value.trim();
    }

    public static Long parseLong(String recordCount) {
        try {
            long l = Long.parseLong(recordCount);
            return l;
        } catch (Exception e) {
            return 0L;
        }
    }
}
