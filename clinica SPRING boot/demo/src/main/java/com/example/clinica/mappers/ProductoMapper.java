package com.example.clinica.mappers;

import org.springframework.stereotype.Component;
import com.example.clinica.entities.Producto;
import com.example.clinica.dtos.CreateProductoDto;
import com.example.clinica.dtos.GetProductoDto;

@Component
public class ProductoMapper {

    // De CreateProductoDto a Producto (para crear)
    public Producto toProducto(CreateProductoDto dto) {
        Producto producto = new Producto();
        producto.setNombre(dto.getNombre());
        producto.setMarca(dto.getMarca());
        producto.setCategoria(dto.getCategoria());
        producto.setEspecies(dto.getEspecies());
        producto.setDescripcion(dto.getDescripcion());
        producto.setImagen(dto.getImagen());
        producto.setPrecio(dto.getPrecio());
        return producto;
    }

    // De Producto a GetProductoDto (para mostrar)
    public GetProductoDto toGetProductoDto(Producto producto) {
        GetProductoDto dto = new GetProductoDto();
        dto.setId(producto.getId());
        dto.setNombre(producto.getNombre());
        dto.setMarca(producto.getMarca());
        dto.setCategoria(producto.getCategoria());
        dto.setEspecies(producto.getEspecies());
        dto.setDescripcion(producto.getDescripcion());
        dto.setImagen(producto.getImagen());
        dto.setPrecio(producto.getPrecio());
        return dto;
    }
}

