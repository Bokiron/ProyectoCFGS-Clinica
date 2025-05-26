package com.example.clinica.exceptions;

public class CarritoNotFoundException extends RuntimeException {
    public CarritoNotFoundException(Long id) {
        super("No se encontró el carrito " + id);
    }
}
