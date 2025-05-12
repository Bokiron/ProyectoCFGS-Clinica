package com.example.clinica.advices;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.example.clinica.exceptions.MascotaNotFoundException;

public class MascotaExceptionAdvice extends RuntimeException {
    @ExceptionHandler(MascotaNotFoundException.class)
    @ResponseStatus(code = HttpStatus.NOT_FOUND)
    String clienteNotFoundHandler(MascotaNotFoundException ex) {
        return ex.getMessage();
    }

}
