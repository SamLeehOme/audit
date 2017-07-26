package com.yingu.project.audit.web.utils;

/**
 * Created by user on 2016/11/15.
 */
public class EnumUtil {

    public static Enum Str2Enum(String str, Class c){
        Enum n = Enum.valueOf(c, str);
        try{
            n = Enum.valueOf(c, str);
        } catch (Exception e){
            return null;
        }
        return n;
    }

}
