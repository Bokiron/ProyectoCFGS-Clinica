package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Servicio;
import java.util.List;

@Repository
public interface CitaRepository extends JpaRepository<Cita, Long> {
    List<Cita> findByMascotaId(Long mascotaId); // Obtener citas de una mascota
    List<Cita> findByEspacio(String espacio);
    List<Cita> findByServicio(Servicio servicio);

}
