package com.example.clinica.mappers;

import org.springframework.stereotype.Component;

import com.example.clinica.dtos.CreateMascotaDto;
import com.example.clinica.dtos.GetMascotaDto;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Usuario;

@Component
public class MascotaMapper {

    public Mascota toMascota(CreateMascotaDto dto, Usuario usuario) {
        return new Mascota(
            dto.getId(),
            dto.getNombre(),
            dto.getEspecie(),
            dto.getRaza(),
            dto.getFechaNacimiento(),
            usuario
        );
    }

    public GetMascotaDto toGetMascotaDto(Mascota mascota) {
        return new GetMascotaDto(
            mascota.getId(),
            mascota.getNombre(),
            mascota.getEspecie(),
            mascota.getRaza(),
            mascota.getFechaNacimiento(),
            mascota.getUsuario()
        );
    }
}
