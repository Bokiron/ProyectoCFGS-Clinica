package com.example.clinica.exceptions;

public class LineaCarritoNotFoundException extends RuntimeException {
    public LineaCarritoNotFoundException(Long id) {
        super("No se encontró la linea de carrito " + id);
    }
}
