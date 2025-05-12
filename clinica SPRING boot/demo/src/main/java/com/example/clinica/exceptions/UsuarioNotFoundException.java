package com.example.clinica.exceptions;

public class UsuarioNotFoundException extends RuntimeException {
    public UsuarioNotFoundException(Long id) {
        super("No se encontró el usuario " + id);
    }
}
