package com.example.clinica.exceptions;

public class MascotaNotFoundException extends RuntimeException {
    public MascotaNotFoundException(Long id) {
        super("No se encontró la mascota " + id);
    }
}
