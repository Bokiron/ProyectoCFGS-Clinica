package com.example.clinica.mappers;

import org.springframework.stereotype.Component;

import com.example.clinica.dtos.CreateServicioDto;
import com.example.clinica.dtos.GetServicioDto;
import com.example.clinica.entities.Servicio;

@Component
public class ServicioMapper {

    public Servicio toServicio(CreateServicioDto dto) {
        return new Servicio(
            dto.getId(),
            dto.getNombre(),
            dto.getPrecio()
        );
    }

    public GetServicioDto toGetServicioDto(Servicio servicio) {
        return new GetServicioDto(
            servicio.getId(),
            servicio.getNombre(),
            servicio.getPrecio()
        );
    }
}
