package com.example.clinica.advices;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.example.clinica.exceptions.UsuarioNotFoundException;

public class UsuarioExceptionAdvice extends RuntimeException {
    @ExceptionHandler(UsuarioNotFoundException.class)
    @ResponseStatus(code = HttpStatus.NOT_FOUND)
    String clienteNotFoundHandler(UsuarioNotFoundException ex) {
        return ex.getMessage();
    }
}
