package com.example.clinica.services;

import com.example.clinica.dtos.*;
import com.example.clinica.entities.*;
import com.example.clinica.mappers.*;
import com.example.clinica.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CarritoService {

    @Autowired
    private CarritoRepository carritoRepository;

    @Autowired
    private LineaCarritoRepository lineaCarritoRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    // Obtener el carrito de un usuario
    public Optional<GetCarritoDto> getCarrito(String usuarioDni) {
        return carritoRepository.findByUsuarioDni(usuarioDni)
            .map(CarritoMapper::toGetCarritoDto);
    }

    // Vaciar el carrito de un usuario
    @Transactional
    public void vaciarCarrito(String usuarioDni) {
        Optional<Carrito> carritoOpt = carritoRepository.findByUsuarioDni(usuarioDni);
        carritoOpt.ifPresent(carrito ->
            lineaCarritoRepository.deleteByCarritoId(carrito.getId())
        );
    }

    // Añadir una línea al carrito
    @Transactional
    public Optional<GetLineaCarritoDto> addLineaCarrito(String usuarioDni, CreateLineaCarritoDto dto) {
        // Buscar o crear el carrito
        Carrito carrito = carritoRepository.findByUsuarioDni(usuarioDni)
            .orElseGet(() -> {
                Usuario usuario = usuarioRepository.findById(usuarioDni)
                    .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
                Carrito nuevoCarrito = new Carrito();
                nuevoCarrito.setUsuario(usuario);
                return carritoRepository.save(nuevoCarrito);
            });

        // Buscar el producto
        Producto producto = productoRepository.findById(dto.getProductoId())
            .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

        // Buscar si ya existe una línea para ese producto en el carrito
        Optional<LineaCarrito> lineaExistente = lineaCarritoRepository.findByCarritoIdAndProductoId(
            carrito.getId(), producto.getId());

        LineaCarrito linea;
        if (lineaExistente.isPresent()) {
            // Si ya existe, actualizar la cantidad
            linea = lineaExistente.get();
            linea.setCantidad(linea.getCantidad() + dto.getCantidad());
        } else {
            // Si no existe, crear una nueva línea
            linea = LineaCarritoMapper.toEntity(dto, carrito, producto);
        }
        linea = lineaCarritoRepository.save(linea);

        return Optional.of(LineaCarritoMapper.toGetLineaCarritoDto(linea));
    }

    // Actualizar una línea del carrito
    @Transactional
    public Optional<GetLineaCarritoDto> updateLineaCarrito(
        String usuarioDni, Long lineaId, CreateLineaCarritoDto dto) {

        Optional<LineaCarrito> lineaOpt = lineaCarritoRepository.findById(lineaId);
        if (lineaOpt.isEmpty()) {
            return Optional.empty();
        }
        LineaCarrito linea = lineaOpt.get();
        // Verificar que la línea pertenece al carrito del usuario
        if (!linea.getCarrito().getUsuario().getDni().equals(usuarioDni)) {
            throw new RuntimeException("No tienes permiso para modificar esta línea");
        }
        // Actualizar la cantidad y la selección
        linea.setCantidad(dto.getCantidad());
        linea.setSeleccionado(dto.isSeleccionado());
        linea = lineaCarritoRepository.save(linea);
        return Optional.of(LineaCarritoMapper.toGetLineaCarritoDto(linea));
    }

    // Eliminar una línea del carrito
    @Transactional
    public boolean deleteLineaCarrito(String usuarioDni, Long lineaId) {
        Optional<LineaCarrito> lineaOpt = lineaCarritoRepository.findById(lineaId);
        if (lineaOpt.isEmpty()) {
            return false;
        }
        LineaCarrito linea = lineaOpt.get();
        // Verificar que la línea pertenece al carrito del usuario
        if (!linea.getCarrito().getUsuario().getDni().equals(usuarioDni)) {
            throw new RuntimeException("No tienes permiso para eliminar esta línea");
        }
        lineaCarritoRepository.deleteById(lineaId);
        return true;
    }

    // CarritoService.java
    @Transactional
    public void eliminarLineasSeleccionadas(String usuarioDni, List<Long> idsLineas) {
        // Obtener el carrito del usuario
        Carrito carrito = carritoRepository.findByUsuarioDni(usuarioDni)
            .orElseThrow(() -> new RuntimeException("Carrito no encontrado"));

        // Verificar que todas las líneas pertenecen al carrito del usuario
        for (Long idLinea : idsLineas) {
            LineaCarrito linea = lineaCarritoRepository.findById(idLinea)
                .orElseThrow(() -> new RuntimeException("Línea no encontrada"));
            if (!linea.getCarrito().getId().equals(carrito.getId())) {
                throw new RuntimeException("Una o más líneas no pertenecen al usuario");
            }
        }

        // Eliminar todas las líneas
        lineaCarritoRepository.deleteAllById(idsLineas);
    }

}

