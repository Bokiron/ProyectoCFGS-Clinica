package com.example.clinica.advices;

import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.example.clinica.exceptions.CitaSolapadaException;

    @RestControllerAdvice
    public class GeneralExceptionAdvice {
    
    @ResponseStatus(code = HttpStatus.BAD_REQUEST)
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public String handleRequestBodyTypeMismatchExceptions(HttpMessageNotReadableException ex) {
        return ex.getMessage();
    }

    @ResponseStatus(code = HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(Exception.class)
    public String handleExceptions(Exception ex) {
        return ex.getMessage();
    }

    @ResponseStatus(code = HttpStatus.CONFLICT)
    @ExceptionHandler(CitaSolapadaException.class)
    public String handleCitaSolapada(CitaSolapadaException ex) {
        return ex.getMessage();
    }
}
