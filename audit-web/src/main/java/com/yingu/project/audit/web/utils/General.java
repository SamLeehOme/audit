package com.yingu.project.audit.web.utils;

import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class General {
	/**
	 * 判断某一个元素是否存在于List集合中
	 * @param list
	 * @param obj
	 * @return
	 */
	public static boolean isContain(List list, Object obj){
		boolean flag = false;
		for (Object object : list) {
			if(object == obj){
				flag = true;
			}
		}
		return flag;
	}
	
	/**
	 * 判断字符串是否为空(包含null与"")
	 * @param str
	 * @return
	 */
	public static boolean isEmpty(String str){
		if(str == null || "".equals(str))
			return true;
		return false;
	}
	
	/**
	 * 判断字符串是否为非空(包含null与"")
	 * @param str
	 * @return
	 */
	public static boolean isNotEmpty(String str){
		if(str == null || "".equals(str))
			return false;
		return true;
	}
	
	/**
	 * 字符串去空格方法
	 * @param str
	 * @return
	 */
	public static String trim(String str){
		if(str == null)
			return "";
		return str.trim();
	}
	
	/**
	 * 替换字符串
	 * @param src 源字符串
	 * @param oldstr 要替换的字符串
	 * @param newstr 新字符串
	 * @return
	 */
	public static String replace(String src, String oldstr, String newstr) {
		StringBuffer dest = new StringBuffer();
		int beginIndex = 0;
		int endIndex = 0;
		while (true) {
			endIndex = src.indexOf(oldstr, beginIndex);
			if (endIndex >= 0) {
				dest.append(src.substring(beginIndex, endIndex));
				dest.append(newstr);
				beginIndex = endIndex + oldstr.length();
			} else {
				dest.append(src.substring(beginIndex));
				break;
			}
		}
		return dest.toString();
	}
	
	/**
	 * 防止SQL注入
	 * @param str
	 * @return
	 */
	public static String sqlStr(String str) {
		if (str != null) {
			str = replace(str, "'", "");
			str = replace(str, " ", "");
			str = replace(str, "\\", "&#92;");
		}
		return str;
	}
	
	/**
     * 日期类型转换成yyyy-MM-ddTHH:mm:ss.SSSzzzzz+08.00格式字符串
     * @return String
     */
    public static String xmlDateTime2xmlDateTimeStr(Date date) {
    	if(date == null)
    		return null;
    	
    	Calendar ca = Calendar.getInstance();
    	ca.setTime(date);
    	XMLGregorianCalendar calendar;
    	try {
            calendar = DatatypeFactory.newInstance().newXMLGregorianCalendar((GregorianCalendar)ca);
        } catch(Exception ex){
        	return null;
        }
        return calendar.toString();
    }
	
	/**
     * 获取当前时间戳
     * @return 字符串形式的时间戳
     */
    public static String getTimestamp(){
        return xmlDateTime2xmlDateTimeStr(new Date());
    }
    
    /**
     * 时间字符串转换为long
     * @param timeStr
     * @param format
     * @return
     */
    public static long timeStr2Long(String timeStr, String format){
    	if(format == null)
    		format = "yyyy-MM-dd HH:mm:ss";
    	
    	SimpleDateFormat formatter = new SimpleDateFormat(format);
    	try{
    		return formatter.parse(timeStr).getTime();
    	} catch(Exception ex){
    		ex.printStackTrace();
    		return -1;
    	}
    }
    /**
     * long时间转换为字符串
     * @param timeLong
     * @param format
     * @return
     */
    public static String timeLong2Str(Long timeLong, String format){
    	if(timeLong == null)
    		return null;
    	if(format == null)
    		format = "yyyy-MM-dd HH:mm:ss";
    	SimpleDateFormat formatter = new SimpleDateFormat(format);
    	Date date = new Date(timeLong);
    	return formatter.format(date);
    }
    
    /**
     * 将空字符串转换为""
     * @param str
     * @return
     */
    public static String convertNullToEmpty(String str){
    	if(General.isEmpty(str))
    		return "";
    	return str;
    }
    
	/**
	 * 判断是否为数字
	 * @param str
	 * @return
	 */
	public static boolean isNumber(String str) {
		try{
			Integer.parseInt(str);
			return true;
		}catch(Exception ex){
			return false;
		}
	}
	
	/**
	 * URL编码方法
	 * @param url
	 * @param encode 字符集 默认为UTF-8
	 * @return
	 */
	public static String encodeURL(String url, String encode) {
		if(General.isEmpty(encode)) encode = "utf8";
		try {
			return java.net.URLEncoder.encode(url, encode);
		} catch (UnsupportedEncodingException e) {
			return url;
		}
	}
	
	/**
	 * URL解码方法
	 * @param url
	 * @param decode 字符集 默认为UTF-8
	 * @return
	 */
	public static String decodeURL(String url, String decode) {
		String u = url;
		if(General.isEmpty(decode)) decode = "utf8";
		try {
			u = java.net.URLDecoder.decode(url, decode);
		} catch (Exception e) {
			return url;
		}
		return u;
	}
	
	/**
	 * 用指定分隔符分隔字符串
	 * @param str
	 * @param separator
	 * @return
	 */
	public static List<String> segmentationStr(String str,String separator){
		List<String> result = new ArrayList<String>();
		if(General.isEmpty(str))
			return result;
		StringTokenizer token = new StringTokenizer(str, separator);
		while (token.hasMoreElements()) {
			result.add(token.nextToken());
		}
		return result;
	}
	
	public static List<Long> segmentationStr2Integer(String str,String separator){
		List<Long> result = new ArrayList<Long>();
		if(General.isEmpty(str))
			return result;
		StringTokenizer token = new StringTokenizer(str, separator);
		while (token.hasMoreElements()) {
			result.add(Long.parseLong(token.nextToken()));
		}
		return result;
	}
	
	/**
	 * 判断字符串是否为合法手机号 11位 13 14 15 18开头
	 * @param str
	 * @return boolean
	 */
	public static boolean isMobile(String str){
		if(General.isEmpty(str))
			return false;
		return str.matches("^(13|14|15|18)\\d{9}$");
	}
	
	/**
	 * 判断是否为正确的邮件格式
	 * @param str
	 * @return boolean
	 */
	public static boolean isEmail(String str){
		if(General.isEmpty(str))
			return false;
		return str.matches("^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$");
	}
	
	/**
	 * HTML字符串编码
	 * @param str
	 * @return
	 */
	public static String HTMLEncode(String str) {
		if (str != null) {
			//需要放在前面替换，以防止替换掉其他已经替换过一次的，如 "\\", "&#92;"  lixinglei modify  at 2012-06-15
			str = replace(str, "&", "&amp;");
			str = replace(str, "'", "&#39;");
			str = replace(str, "\"", "&quot;");
			str = replace(str, "<", "&lt;");
			str = replace(str, ">", "&gt;");
			str = replace(str, "<<", "&raquo;");
			str = replace(str, ">>", "&laquo;");
			str = replace(str, "'", "");	//??
			str = replace(str, "\"", "");	//??
			str = replace(str, "\\r\\n", "\n"); //lixinglei modify  at 2012-06-15
			str = replace(str, "\\n", "<br>"); //lixinglei modify  at 2012-06-15
			str = replace(str, "\r\n", "\n");
			str = replace(str, "\n", "<br>");
			//需要放在\n之后替换，以防止替换掉\n的\ lixinglei modify  at 2012-06-15
			str = replace(str, "\\", "&#92;");
			str = replace(str, "  ", "　");
			str = replace(str, "&amp;amp;", "&amp;");	//??
			str = replace(str, "&amp;quot;", "&quot;");	//??
			str = replace(str, "&amp;lt;", "&lt;");		//??
			str = replace(str, "&amp;gt;", "&gt;");		//??
			str = replace(str, "&amp;nbsp;", "&nbsp;");	//??
		}
		return str;
	}
	
	/**
	 * 获得指定格式的时间
	 * @param date
	 * @param formatStr
	 * @return
	 */
	public static String getDateByFormat(Date date, String formatStr){
        if (date == null){
            return null;
        }
        
        SimpleDateFormat sf = new SimpleDateFormat(formatStr);
        return sf.format(date);
    }
	
	/**
	 * 判断是否为浮点数或者整数
	 * @param str
	 * @return true Or false
	 * add by Shi weiyan
	 */
	public static boolean isNumeric(String str){
          Pattern pattern = Pattern.compile("^(-?\\d+)(\\.\\d+)?$");
          Matcher isNum = pattern.matcher(str);
          if( !isNum.matches() ){
                return false;
          }
          return true;
    }
	
	/**
	 * URL参数编码
	 * @param url
	 * @return
	 */
	public static String encodeURLParam(String url,String charset){
		if(url==null) return null;
		int rex = url.indexOf("=");
		if(rex == -1) return url;
		
		StringBuffer sb = new StringBuffer();
		List<String> list = General.segmentationStr(url, "=");
		for(int i=0;i<list.size();i++){
			String temp = list.get(i);
			if(i==0) sb.append(temp).append("=");
			else{
				if(temp.indexOf("&") ==0){
					sb.append(temp).append("=");
				}else if(temp.indexOf("&") == -1)
					sb.append(General.encodeURL(temp, charset));
				else{
					sb.append(General.encodeURL(temp.substring(0, temp.indexOf("&")), charset)).append(temp.substring(temp.indexOf("&")));
					sb.append("=");
				}
			}
		}
		return sb.toString();
	}
	
	/**
	 * 依据格式获取当前时间
	 * @param format
	 * @return
	 */
	public static String getNow(String format){
		if(null == format || "".equals(format)){
			format = "yyyy-MM-dd HH:mm:ss";
		}
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		Date date = new Date();
		return formatter.format(date);
	}
	
	
	/**
	 * 以|线开始，且以|线结束
	 */
	public static String startAndEndWithVerticalBar(String string){
		if(General.isEmpty(string)){
			return null;
		}
		if(General.isEmpty(string.replaceAll("|", "").trim())){
			return null;
		}
		if(!string.startsWith("|")){
			string = "|"+string;
		}
		if(!string.endsWith("|")){
			string = string + "|";
		}
		return string;
	}
	/**
	 * 去掉数组中值想等的字符串
	 * @param tagList
	 */
	public static void trimArrayList(List<String> tagList) {
		Set<String> set = new HashSet<String>();
		Iterator<String> it = tagList.iterator();
		String str = null;
		while(it.hasNext()){
			 str = it.next(); 
             if(set.contains(str))   it.remove(); 
             else   set.add(str);
		}
	}
	public static String getCurrentMonth(){
		int month=0;
		Calendar calendar = Calendar.getInstance();
		month=calendar.get(Calendar.MONTH);
		month +=1;
		if(month<10){
			return "0"+month;
		}else{
			return ""+month;
		}
	}
	
	public static String upperFirstLetter(String str){
		return str.substring(0,1).toUpperCase() + str.substring(1);
	}
	
	public static String lowerFirstLetter(String str){
		return str.substring(0,1).toLowerCase() + str.substring(1);
	}
	
	public static Integer grandson(){
		int random=(int)(Math.random()*10000000); 
		return random;
	}
}
