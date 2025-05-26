package com.example.clinica.controllers;

import com.example.clinica.dtos.*;
import com.example.clinica.entities.*;
import com.example.clinica.mappers.*;
import com.example.clinica.repositories.*;
import com.example.clinica.services.CarritoService;

import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/carrito")
public class CarritoController {

    @Autowired
    private CarritoRepository carritoRepository;

    @Autowired
    private LineaCarritoRepository lineaCarritoRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository; // Asegúrate de que existe

    @Autowired
    private CarritoService carritoService;

    // Obtener el carrito de un usuario
    @GetMapping("/{usuarioDni}")
    public ResponseEntity<GetCarritoDto> getCarrito(@PathVariable String usuarioDni) {
        Optional<Carrito> carritoOpt = carritoRepository.findByUsuarioDni(usuarioDni);
        if (carritoOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        GetCarritoDto dto = CarritoMapper.toGetCarritoDto(carritoOpt.get());
        return ResponseEntity.ok(dto);
    }

    // Vaciar el carrito de un usuario
    @DeleteMapping("/{usuarioDni}")
    public ResponseEntity<Void> vaciarCarrito(@PathVariable String usuarioDni) {
        carritoService.vaciarCarrito(usuarioDni);
        return ResponseEntity.noContent().build();
    }

    // Añadir una línea al carrito
    @PostMapping("/{usuarioDni}/linea")
    public ResponseEntity<GetLineaCarritoDto> addLineaCarrito(
            @PathVariable String usuarioDni,
            @RequestBody CreateLineaCarritoDto dto) {
        // Buscar el carrito o crearlo si no existe
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

        GetLineaCarritoDto lineaDto = LineaCarritoMapper.toGetLineaCarritoDto(linea);
        return ResponseEntity.ok(lineaDto);
    }

    // Actualizar una línea del carrito (por ejemplo, cambiar la cantidad o la selección)
    @PutMapping("/{usuarioDni}/linea/{lineaId}")
    public ResponseEntity<GetLineaCarritoDto> updateLineaCarrito(
            @PathVariable String usuarioDni,
            @PathVariable Long lineaId,
            @RequestBody CreateLineaCarritoDto dto) {
        Optional<LineaCarrito> lineaOpt = lineaCarritoRepository.findById(lineaId);
        if (lineaOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        LineaCarrito linea = lineaOpt.get();
        // Verificar que la línea pertenece al carrito del usuario
        if (!linea.getCarrito().getUsuario().getDni().equals(usuarioDni)) {
            return ResponseEntity.status(403).build();
        }
        // Actualizar la cantidad y la selección
        linea.setCantidad(dto.getCantidad());
        linea.setSeleccionado(dto.isSeleccionado());
        linea = lineaCarritoRepository.save(linea);
        GetLineaCarritoDto lineaDto = LineaCarritoMapper.toGetLineaCarritoDto(linea);
        return ResponseEntity.ok(lineaDto);
    }

    // Eliminar una línea del carrito
    @DeleteMapping("/{usuarioDni}/linea/{lineaId}")
    public ResponseEntity<Void> deleteLineaCarrito(
            @PathVariable String usuarioDni,
            @PathVariable Long lineaId) {
        Optional<LineaCarrito> lineaOpt = lineaCarritoRepository.findById(lineaId);
        if (lineaOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        LineaCarrito linea = lineaOpt.get();
        // Verificar que la línea pertenece al carrito del usuario
        if (!linea.getCarrito().getUsuario().getDni().equals(usuarioDni)) {
            return ResponseEntity.status(403).build();
        }
        lineaCarritoRepository.deleteById(lineaId);
        return ResponseEntity.noContent().build();
    }

    //Eliminar varios productos(varias lineas de carrito)
    @PostMapping("/{usuarioDni}/lineas/eliminar")
    @Transactional
    public ResponseEntity<Void> eliminarLineas(
        @PathVariable String usuarioDni,
        @RequestBody List<Long> idsLineas) {
        // Verificar que todas las líneas pertenecen al usuario
        for (Long id : idsLineas) {
            Optional<LineaCarrito> lineaOpt = lineaCarritoRepository.findById(id);
            if (lineaOpt.isEmpty() || !lineaOpt.get().getCarrito().getUsuario().getDni().equals(usuarioDni)) {
                return ResponseEntity.status(403).build();
            }
        }
        // Eliminar las líneas
        lineaCarritoRepository.deleteAllById(idsLineas);
        return ResponseEntity.noContent().build();
    }

}

