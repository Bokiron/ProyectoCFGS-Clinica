package com.example.clinica.repositories;

import com.example.clinica.entities.Carrito;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface CarritoRepository extends JpaRepository<Carrito, Long> {
    // Buscar el carrito de un usuario por su DNI
    Optional<Carrito> findByUsuarioDni(String dni);

    // Opcional: eliminar el carrito de un usuario
    void deleteByUsuarioDni(String dni);
}
