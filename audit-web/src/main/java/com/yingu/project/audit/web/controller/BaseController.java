package com.yingu.project.audit.web.controller;

import net.sf.json.JSONArray;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.http.*;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


/**
 * Created by admi on 2016/10/28.
 */
public class BaseController {
    protected HttpServletRequest request;
    protected HttpServletResponse response;
    protected HttpSession session;
    private String serverUrl;
    public static final String SUCCESS="{\"success\":true}";

    @ModelAttribute
    public void setReqAndRes(HttpServletRequest request, HttpServletResponse response){
        this.request = request;
        this.response = response;
        this.session = request.getSession();
    }


    public static final String AJAX = "ajax";

    protected String getClientIp() {
        return request.getRemoteAddr();
    }

    protected String getContextPath() {
        return request.getContextPath();
    }

    protected String ajaxOut(Object obj) {
        String jsonString = JSONArray.fromObject(obj).toString();
        return ajaxOut(jsonString);
    }

    protected String ajaxOut(List list) {
        String jsonString = JSONArray.fromObject(list).toString();
        return ajaxOut(jsonString);
    }

    protected String ajaxOutLimit(Object obj) {
        String jsonString = JSONArray.fromObject(obj).toString();
        return ajaxOut(jsonString);
    }

    protected JSONArray jsonArray(String jsonString) {
        JSONArray jsArray = JSONArray.fromObject(jsonString);
        return jsArray;
    }



    protected String ajaxOut(Map map) {
        String jsonString = JSONArray.fromObject(map).toString();
        return ajaxOut(jsonString.substring(1,jsonString.length()-1));
    }


    protected String ajaxOut(String jsonString) {
        response.setContentType("text/html;charset=utf-8");
        try {
            response.getWriter().print(jsonString);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    protected String ajaxOut() throws Exception {
        return null;
    }



    public void download(String[] filePaths,String title ){
        response.setContentType("APPLICATION/OCTET-STREAM");
        //关键！
        response.setHeader("Content-Disposition","attachment; filename="+title);
        ZipOutputStream zos = null;
        try {
            //技巧：多文件下载，有人经常先将所有的文件压缩成一个zip包，写到某个真实的路径下。再用FileInputStream读取，最后以单文件下载的方式提供下载，并且删除生成压缩包。
            //解决方案：new ZipOutputStream(response.getOutputStream());--> 直接读取response的流，直接写到页面上，不会真实的保存zip文件。
            zos = new ZipOutputStream(response.getOutputStream());
            File[] files = new File[filePaths.length];
            for (int i = 0; i < filePaths.length; i++) {
                files[i] = new File(filePaths[i]);
            }
            zipFile(files, "", zos);
            zos.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally{
            try {
                zos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void zipFile(File[] subs, String baseName, ZipOutputStream zos) throws IOException {
        for (int i=0;i<subs.length;i++) {
            File f=subs[i];
            zos.putNextEntry(new ZipEntry(baseName + f.getName()));
            FileInputStream fis = new FileInputStream(f);
            byte[] buffer = new byte[1024];
            int r = 0;
            while ((r = fis.read(buffer)) != -1) {
                zos.write(buffer, 0, r);
            }
            fis.close();
        }
    }

    public void download(String filePath,String title){
        response.setContentType("text/html;charset=UTF-8");
        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
        try {
            request.setCharacterEncoding("UTF-8");
            long fileLength = new File(filePath).length();
            response.setContentType("application/octet-stream");
            response.setHeader("Content-disposition", "attachment; filename="
                    + new String(title.getBytes("ISO8859-1"), "UTF-8"));
            response.setHeader("Content-Length", String.valueOf(fileLength));
            bis = new BufferedInputStream(new FileInputStream(filePath));
            bos = new BufferedOutputStream(response.getOutputStream());
            byte[] buff = new byte[2048];
            int bytesRead;
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                bis.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                bos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    protected Object getForObject(String uri,Map<String, String> map, Class c){
        StringBuffer sb = new StringBuffer();
        sb.append(serverUrl).append(uri);
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(sb.toString());
        for(Map.Entry<String, String> entry : map.entrySet())
        {
            builder.queryParam(entry.getKey(), entry.getValue());
        }
        //builder.queryParam("token", CookieUtil.getCookie(request, "userToken"));

        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(builder.build().encode().toUri(), c);
    }

    protected Object getForObject(String uri, Class c){
        StringBuffer sb = new StringBuffer();
        sb.append(serverUrl).append(uri);
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(sb.toString());
        //builder.queryParam("token", CookieUtil.getCookie(request, "userToken"));
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(builder.build().encode().toUri(), c);
    }

    /**
     *
     * @param url url地址
     * @param json 请求参数
     * @param c 需要传递的class
     * @return object
     * @throws Exception
     */
    public Object exchange(String url, String json, String method, Class c)
            throws Exception {
        StringBuffer sb = new StringBuffer(url);
        if(method != null && method.toUpperCase().equals("GET") || method.toUpperCase().equals("POST")
                || method.toUpperCase().equals("PUT") || method.toUpperCase().equals("DELETE")){
            sb.append(url);
        } else {
            return null;
        }
        HttpHeaders headers = new HttpHeaders();
        MediaType type = MediaType.parseMediaType("application/json; charset=UTF-8");
        headers.setContentType(type);
        headers.add("Accept", MediaType.APPLICATION_JSON_VALUE);
        //headers.add("token", CookieUtil.getCookie(request, "userToken"));

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity entity = null;
        HttpMethod httpMethod = null;
        switch (method.toUpperCase()){
            case "GET" : {
                if(url.indexOf("?") == -1){
                    sb.append("?");
                } else {
                    sb.append("&");
                }
                //sb.append("token=").append(CookieUtil.getCookie(request, "userToken"));
                httpMethod = HttpMethod.GET;
                break;
            }
            case "POST" : {
                httpMethod = HttpMethod.POST;
                break;
            }
            case "PUT" : {
                httpMethod = HttpMethod.PUT;
                break;
            }
            case "DELETE" : {
                httpMethod = HttpMethod.DELETE;
                break;
            }
        }
        HttpEntity<String> formEntity = new HttpEntity<String>(json, headers);
        entity = restTemplate.exchange(sb.toString(), httpMethod, formEntity, c);
        return entity == null ? null : entity.getBody();
    }

    protected Object postForEntity(String url, MultiValueMap<String, String> map){
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        //headers.add("token", CookieUtil.getCookie(request, "userToken"));
        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<MultiValueMap<String, String>>(map, headers);
        RestTemplate rest = new RestTemplate();
        ResponseEntity<String> responseEntity = rest.postForEntity(serverUrl +url, request, String.class);
        if(responseEntity != null && responseEntity.getStatusCode() == HttpStatus.OK){
            return responseEntity.getBody();
        }
        return responseEntity.getStatusCode();
    }

    public void setServerUrl(String serverUrl) {
        this.serverUrl = serverUrl;
    }

    public String getServerUrl() {
        return serverUrl;
    }
}
