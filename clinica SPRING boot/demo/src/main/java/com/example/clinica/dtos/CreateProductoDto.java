
package com.example.clinica.dtos;

import java.math.BigDecimal;
import java.util.List;

import com.example.clinica.entities.Producto.CategoriaProducto;
import com.example.clinica.entities.Producto.EspecieProducto;
import lombok.*;

@Getter//genera getters
@Setter//genera stters
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CreateProductoDto {
    private String nombre;
    private String marca;
    private CategoriaProducto categoria;
    private List<EspecieProducto> especies;
    private String descripcion;
    private String imagen; // nombre de archivo o ruta relativa
    private BigDecimal precio;
}

