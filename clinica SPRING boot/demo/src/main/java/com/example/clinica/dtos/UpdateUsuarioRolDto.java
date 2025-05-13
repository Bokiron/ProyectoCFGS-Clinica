package com.example.clinica.dtos;

import com.example.clinica.entities.Usuario.Rol;
import lombok.Data;

@Data
public class UpdateUsuarioRolDto {
    private Rol rol;
}
