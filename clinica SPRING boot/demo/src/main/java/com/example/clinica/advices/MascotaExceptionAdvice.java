package com.example.clinica.advices;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.example.clinica.exceptions.MascotaNotFoundException;

@RestControllerAdvice
public class MascotaExceptionAdvice {
    @ExceptionHandler(MascotaNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String mascotaNotFoundHandler(MascotaNotFoundException ex) {
        return ex.getMessage();
    }
}
