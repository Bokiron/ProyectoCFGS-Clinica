package com.example.clinica.dtos;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GetUsuarioDto {
    private String dni;
    private String nombre;
    private String email;
    private String telefono;
    private String rol; 
}
