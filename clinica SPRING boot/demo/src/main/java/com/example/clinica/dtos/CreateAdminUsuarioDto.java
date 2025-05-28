package com.example.clinica.dtos;

import com.example.clinica.entities.Usuario;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CreateAdminUsuarioDto {
    @NotBlank private String dni;
    @NotBlank private String nombre;
    @NotBlank private String apellidos;
    @NotBlank private String email;
    @NotBlank private String telefono;
    private Usuario.Rol rol; // Campo opcional para admins
}