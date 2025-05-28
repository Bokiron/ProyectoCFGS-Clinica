package com.example.clinica.exceptions;

public class CitaNotFoundException extends RuntimeException {
    public CitaNotFoundException(Long id) {
        super("No se encontró la cita " + id);
    }
}

