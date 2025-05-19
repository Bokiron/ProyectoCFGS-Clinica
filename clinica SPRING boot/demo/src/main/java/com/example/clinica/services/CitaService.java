package com.example.clinica.services;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.clinica.dtos.CreateCitaDto;
import com.example.clinica.dtos.GetCitaDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;
import com.example.clinica.entities.Usuario;
import com.example.clinica.mappers.CitaMapper;
import com.example.clinica.repositories.CitaRepository;

@Service // Indica que esta clase es un servicio de Spring
public class CitaService {

    private final CitaRepository citaRepository;
    private final CitaMapper citaMapper;

    // Constructor para intorducir el repositorio de citas y el mapper
    public CitaService(CitaRepository citaRepository, CitaMapper citaMapper) {
        this.citaRepository = citaRepository;
        this.citaMapper = citaMapper;
    }

    // Obtiene todas las citas de la base de datos y las convierte a DTOs
    public List<GetCitaDto> getAllCitas() {
        return citaRepository.findAll()
                .stream()
                .map(citaMapper::toGetCitaDto) // Convierte cada entidad Cita a GetCitaDto
                .collect(Collectors.toList()); // Retorna la lista de DTOs
    }

    // Obtiene una cita por ID y la convierte a DTO
    public Optional<GetCitaDto> getCitaById(Long id) {
        return citaRepository.findById(id).map(citaMapper::toGetCitaDto);
    }

    // Crea una nueva cita con los datos proporcionados
    public Cita createCita(CreateCitaDto dto, Mascota mascota, Servicio servicio, Usuario usuario) {
        Cita nuevaCita = citaMapper.toCita(dto, mascota, servicio, usuario); // Convierte el DTO a entidad
        return citaRepository.save(nuevaCita); // Guarda en la base de datos y retorna la cita creada
    }

    // Actualiza completamente una cita existente
    public Optional<Cita> updateCita(Long id, CreateCitaDto dto, Mascota mascota, Servicio servicio) {
        return citaRepository.findById(id).map(cita -> { // Busca la cita por ID
            // Actualiza los datos de la cita
            cita.setFechaCita(LocalDateTime.of(dto.getFecha(), dto.getHora()));
            cita.setMotivo(dto.getMotivo());
            cita.setMascota(mascota);
            cita.setServicio(servicio);
            return citaRepository.save(cita); // Guarda los cambios en la base de datos
        });
    }

    // Elimina una cita si existe
    public boolean deleteCita(Long id) {
        if (citaRepository.existsById(id)) { // Verifica si la cita existe
            citaRepository.deleteById(id); // Elimina la cita
            return true;
        }
        return false; // Retorna false si la cita no existía
    }
}

