package com.example.clinica.mappers;

import org.springframework.stereotype.Component;

import com.example.clinica.dtos.CreateUsuarioDto;
import com.example.clinica.dtos.GetUsuarioDto;
import com.example.clinica.entities.Usuario;
import com.example.clinica.entities.Usuario.Rol;

@Component
public class UsuarioMapper {

    public Usuario toUsuario(CreateUsuarioDto dto) {
        return new Usuario(
            dto.getDni(),
            dto.getNombre(),
            dto.getApellidos(),
            dto.getEmail(),
            dto.getTelefono(),
            Rol.valueOf(dto.getRol().toUpperCase()) // Convierte String a Enum
        );
    }

    public GetUsuarioDto toGetUsuarioDto(Usuario usuario) {
        return new GetUsuarioDto(
            usuario.getDni(),
            usuario.getNombre(),
            usuario.getEmail(),
            usuario.getTelefono(),
            usuario.getRol().name() // Convierte Enum a String
        );
    }
}
