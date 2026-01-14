package com.example.TeamProject.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

// 이 클래스가 애플리케이션 전역의 예외를 처리하도록 지정
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    // 모든 종류의 예외(Exception.class)를 이 메소드가 처리하도록 지정
    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(Exception ex) {

        // 1. 에러 로그를 콘솔이나 파일에 기록
        logger.error("Exception occurred: ", ex);

        // 2. 사용자에게 보여줄 에러 페이지와 전달할 정보를 설정
        ModelAndView mv = new ModelAndView();
        mv.setViewName("main/error"); 
        mv.addObject("errorMessage", ex.getMessage()); 

        return mv;
    }
}