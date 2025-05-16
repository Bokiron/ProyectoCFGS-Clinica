package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.example.clinica.entities.Mascota;
import java.util.List;

@Repository
public interface MascotaRepository extends JpaRepository<Mascota, Long> {
    List<Mascota> findByUsuarioDni(String usuarioDni); // Buscar todas las mascotas de un usuario

    // Consulta personalizada para buscar por DNI o email
    @Query("SELECT m FROM Mascota m WHERE m.usuario.dni = :dniOrEmail OR m.usuario.email = :dniOrEmail")
    List<Mascota> findByUsuarioDniOrEmail(String dniOrEmail);
}
