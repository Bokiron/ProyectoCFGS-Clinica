package com.example.clinica.dtos;

import java.math.BigDecimal;
import lombok.*;

@Data
public class GetLineaCarritoDto {
    private Long id;
    private Long productoId;
    private int cantidad;
    private boolean seleccionado;
    private String nombreProducto;
    private String marcaProducto;
    private BigDecimal precioProducto;
    private String imagenProducto;
}

