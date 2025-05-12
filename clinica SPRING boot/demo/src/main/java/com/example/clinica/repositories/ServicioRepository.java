package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.clinica.entities.Servicio;

@Repository
public interface ServicioRepository extends JpaRepository<Servicio, Long> {
}
