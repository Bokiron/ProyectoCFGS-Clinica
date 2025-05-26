package com.example.clinica.repositories;

import com.example.clinica.entities.LineaCarrito;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface LineaCarritoRepository extends JpaRepository<LineaCarrito, Long> {
    // Buscar todas las líneas de un carrito
    List<LineaCarrito> findByCarritoId(Long carritoId);

    // Buscar una línea específica de un carrito y un producto
    Optional<LineaCarrito> findByCarritoIdAndProductoId(Long carritoId, Long productoId);

    // Eliminar una línea por ID
    void deleteById(Long id);

    // Eliminar todas las líneas de un carrito (útil para vaciar el carrito)
    void deleteByCarritoId(Long carritoId);
}

