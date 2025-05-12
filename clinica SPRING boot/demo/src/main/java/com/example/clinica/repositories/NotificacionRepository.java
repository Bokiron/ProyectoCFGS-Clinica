package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.clinica.entities.Notificacion;

import java.util.List;

@Repository
public interface NotificacionRepository extends JpaRepository<Notificacion, Long> {
    List<Notificacion> findByCitaId(Long citaId); // Obtener notificaciones de una cita
    List<Notificacion> findByCita_Mascota_Usuario_Dni(String dni);

}
