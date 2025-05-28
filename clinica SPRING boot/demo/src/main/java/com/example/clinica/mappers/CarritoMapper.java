package com.example.clinica.mappers;

import com.example.clinica.dtos.*;
import com.example.clinica.entities.*;

import java.util.List;
import java.util.stream.Collectors;

public class CarritoMapper {

    // Convertir línea de carrito a LineaCarritoGetDTO
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

    // Convertir línea de carrito (CreateDTO) a entidad
    public static LineaCarrito toLineaCarritoEntity(CreateLineaCarritoDto dto, Carrito carrito, Producto producto) {
        LineaCarrito linea = new LineaCarrito();
        linea.setCarrito(carrito);
        linea.setProducto(producto);
        linea.setCantidad(dto.getCantidad());
        linea.setSeleccionado(dto.isSeleccionado());
        return linea;
    }

    // Convertir carrito a CarritoGetDTO
    public static GetCarritoDto toGetCarritoDto(Carrito carrito) {
        GetCarritoDto dto = new GetCarritoDto();
        dto.setId(carrito.getId());
        dto.setUsuarioDni(carrito.getUsuario().getDni());
        List<GetLineaCarritoDto> lineasDTO = carrito.getLineas().stream()
            .map(CarritoMapper::toGetLineaCarritoDto)
            .collect(Collectors.toList());
        dto.setLineas(lineasDTO);
        return dto;
    }

    // (Opcional) Convertir CarritoCreateDTO a entidad (para inicialización)
    public static Carrito toCarritoEntity(CreateCarritoDto dto, Usuario usuario) {
        Carrito carrito = new Carrito();
        carrito.setUsuario(usuario);
        // Las líneas se añaden aparte
        return carrito;
    }
}

