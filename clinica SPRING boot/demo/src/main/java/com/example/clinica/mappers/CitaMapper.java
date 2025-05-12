package com.example.clinica.mappers;

import java.time.LocalDateTime;

import org.springframework.stereotype.Component;

import com.example.clinica.dtos.CreateCitaDto;
import com.example.clinica.dtos.GetCitaDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;

@Component
public class CitaMapper {

    public Cita toCita(CreateCitaDto dto, Mascota mascota, Servicio servicio) {
        return new Cita(
            null,  // El id se genera automáticamente
            LocalDateTime.of(dto.getFecha(), dto.getHora()),  //Combina fecha y hora correctamente
            dto.getMotivo(),
            mascota,
            servicio
        );
    }

    public GetCitaDto toGetCitaDto(Cita cita) {
        return new GetCitaDto(
            cita.getId(),
            cita.getFechaCita().toLocalDate(),  // Extrae solo la fecha
            cita.getFechaCita().toLocalTime(),  // Extrae solo la hora
            cita.getMotivo(),
            cita.getMascota(),
            cita.getMascota().getUsuario() // Suponiendo que quieres el usuario dueño de la mascota
        );
    }
}
