package com.example.clinica.dtos;

import java.util.Date;

import com.example.clinica.entities.Usuario;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GetMascotaDto {
    private Long id;
    private String nombre;
    private String especie;
    private String raza;
    private Date fechaNacimiento;
    private Usuario usuario;
}
