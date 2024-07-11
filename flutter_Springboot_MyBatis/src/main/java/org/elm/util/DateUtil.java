package org.elm.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class DateUtil {
    public static String getDate() {
        // 获取当前日期
        LocalDate currentDate = LocalDate.now();

       // 定义日期格式
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        // 格式化日期为字符串
        String formattedDate = currentDate.format(formatter);

        return formattedDate;
    }
    public static void main(String[] args) {
        // 测试
        String currentDate = DateUtil.getDate();
        System.out.println("Current Date: " + currentDate);
    }
}
