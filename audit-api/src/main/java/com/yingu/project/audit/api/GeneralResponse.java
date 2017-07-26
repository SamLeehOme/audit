package com.yingu.project.audit.api;

import com.yingu.project.audit.Status;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2016/11/17.
 */
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class GeneralResponse<T> {
    private Status status;
    private String message;
    private List<T> data = new ArrayList();
    private int currentPage;
    private int totalPage;
    private Long totalSize;
}
