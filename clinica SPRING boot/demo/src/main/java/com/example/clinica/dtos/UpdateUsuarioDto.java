package com.example.clinica.dtos;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateUsuarioDto {
    @NotBlank(message = "nombre es obligatorio")
    private String nombre;
    @NotBlank(message = "apellidos es obligatorio")
    private String apellidos;
    @NotBlank(message = "email es obligatorio")
    private String email;
    @NotBlank(message = "telefono es obligatorio")
    private String telefono;
    private String contrasena; // Opcional: si es null o vacía, no se actualiza
}

