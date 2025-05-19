package com.example.clinica.mappers;

import java.time.LocalDateTime;
import org.springframework.stereotype.Component;
import com.example.clinica.dtos.CreateCitaDto;
import com.example.clinica.dtos.GetCitaDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;
import com.example.clinica.entities.Usuario;

@Component
public class CitaMapper {

    public Cita toCita(CreateCitaDto dto, Mascota mascota, Servicio servicio, Usuario usuario) {
    Cita cita = new Cita();
    cita.setFechaCita(LocalDateTime.of(dto.getFecha(), dto.getHora()));
    cita.setEspacio(Cita.Espacio.valueOf(dto.getEspacio().toUpperCase()));
    cita.setMotivo(dto.getMotivo());
    cita.setEstado(Cita.EstadoCita.valueOf(dto.getEstado().toUpperCase()));//value of para convertir el string a enum
    cita.setMascota(mascota);
    cita.setUsuario(usuario);
    cita.setServicio(servicio);
    return cita;
}

    public GetCitaDto toGetCitaDto(Cita cita) {
    GetCitaDto dto = new GetCitaDto();
    dto.setId(cita.getId());
    dto.setFecha(cita.getFechaCita().toLocalDate());
    dto.setHora(cita.getFechaCita().toLocalTime());
    dto.setEspacio(cita.getEspacio().name());
    dto.setMotivo(cita.getMotivo());
    dto.setEstado(cita.getEstado().name());
    dto.setMascota(cita.getMascota());
    dto.setUsuario(cita.getUsuario());
    dto.setServicio(cita.getServicio());
    return dto;
    }
}
