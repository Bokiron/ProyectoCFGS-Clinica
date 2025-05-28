package com.example.clinica.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.clinica.entities.Cita.Espacio;
import com.example.clinica.entities.Servicio;

@Repository
public interface ServicioRepository extends JpaRepository<Servicio, Long> {
    List<Servicio> findByEspacioServicio(Espacio espacioServicio);
}
