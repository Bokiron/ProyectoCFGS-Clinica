package com.example.clinica.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.clinica.entities.Usuario;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, String> {
    // Aquí puedes definir métodos personalizados si los necesitas
    Optional<Usuario> findByDni(String dni);
}
