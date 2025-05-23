package com.example.clinica.dtos;

import java.math.BigDecimal;
import java.util.List;

import com.example.clinica.entities.Producto.CategoriaProducto;
import com.example.clinica.entities.Producto.EspecieProducto;
import lombok.Data;

@Data
public class UpdateProductoDto {
    private String nombre;
    private String marca;
    private CategoriaProducto categoria;
    private List<EspecieProducto> especies;
    private String descripcion;
    private String imagen;
    private BigDecimal precio;
}

