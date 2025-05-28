package com.example.clinica.dtos;

import com.example.clinica.entities.Cita.Espacio;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GetServicioDto {
    private Long id;
    private String nombre;
    private Double precio;
    private Espacio espacioServicio;
}
