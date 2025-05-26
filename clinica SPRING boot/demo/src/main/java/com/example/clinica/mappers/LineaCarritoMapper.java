package com.example.clinica.mappers;

import com.example.clinica.dtos.CreateLineaCarritoDto;
import com.example.clinica.dtos.GetLineaCarritoDto;
import com.example.clinica.entities.LineaCarrito;
import com.example.clinica.entities.Producto;

public class LineaCarritoMapper {

    // Convertir entidad a LineaCarritoGetDTO
    public static GetLineaCarritoDto toGetLineaCarritoDto(LineaCarrito linea) {
        GetLineaCarritoDto dto = new GetLineaCarritoDto();
        dto.setId(linea.getId());
        dto.setProductoId(linea.getProducto().getId());
        dto.setCantidad(linea.getCantidad());
        dto.setSeleccionado(linea.isSeleccionado());
        dto.setNombreProducto(linea.getProducto().getNombre());
        dto.setMarcaProducto(linea.getProducto().getMarca());
        dto.setPrecioProducto(linea.getProducto().getPrecio());
        dto.setImagenProducto(linea.getProducto().getImagen());
        return dto;
    }

    // Convertir LineaCarritoCreateDTO a entidad
    public static LineaCarrito toEntity(CreateLineaCarritoDto dto, com.example.clinica.entities.Carrito carrito, Producto producto) {
        LineaCarrito linea = new LineaCarrito();
        linea.setCarrito(carrito);
        linea.setProducto(producto);
        linea.setCantidad(dto.getCantidad());
        linea.setSeleccionado(dto.isSeleccionado());
        return linea;
    }
}

