package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Servicio;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface CitaRepository extends JpaRepository<Cita, Long> {
    List<Cita> findByMascotaId(Long mascotaId); // Obtener citas de una mascota
    List<Cita> findByEspacio(String espacio);
    List<Cita> findByServicio(Servicio servicio);
    // Busca citas en el mismo espacio, fecha y hora
    boolean existsByEspacioAndFechaCita(Cita.Espacio espacio, LocalDateTime fechaCita);
    //Lista de horas ocupadas en una fecha y espacio
    List<Cita> findByEspacioAndFechaCitaBetween(Cita.Espacio espacio, LocalDateTime start, LocalDateTime end);
    //Buscar todas las citas de un usuario. Ordenado por fecha, descendiente.
    List<Cita> findByUsuarioDniOrderByFechaCitaAsc(String dni);


}
