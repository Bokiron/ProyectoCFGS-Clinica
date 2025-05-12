package com.example.clinica.exceptions;

public class ServicioNotFoundException extends RuntimeException {
    public ServicioNotFoundException(Long id) {
        super("No se encontró el servicio " + id);
    }
}
