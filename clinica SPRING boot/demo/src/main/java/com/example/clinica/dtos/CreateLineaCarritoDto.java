package com.example.clinica.dtos;

import lombok.*;

@Data
public class CreateLineaCarritoDto {
    private Long productoId;
    private int cantidad;
    private boolean seleccionado;
}

