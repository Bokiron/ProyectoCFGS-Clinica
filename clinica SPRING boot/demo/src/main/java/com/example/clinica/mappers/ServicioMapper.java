package com.example.clinica.mappers;

import org.springframework.stereotype.Component;
import com.example.clinica.dtos.CreateServicioDto;
import com.example.clinica.dtos.GetServicioDto;
import com.example.clinica.entities.Servicio;

@Component
public class ServicioMapper {

    public Servicio toServicio(CreateServicioDto dto) {
        return new Servicio(
            null,
            dto.getNombre(),
            dto.getPrecio(),
            dto.getEspacioServicio()
        );
    }

    public GetServicioDto toGetServicioDto(Servicio servicio) {
        return new GetServicioDto(
            servicio.getId(),
            servicio.getNombre(),
            servicio.getPrecio(),
            servicio.getEspacioServicio()
        );
    }
}
