package com.example.clinica.dtos;


import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter//genera getters
@Setter//genera stters
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CreateMascotaDto {
    private Long id;

    @NotBlank(message = "nombre es obligatorio")
    private String nombre;
    
    @NotBlank(message = "especie es obligatorio")
    private String especie;

    @NotBlank(message = "raza es obligatorio")
    private String raza;

    @NotNull(message = "fechaNacimiento es obligatoria")
    @JsonFormat(pattern = "dd/MM/yyyy")
    @Temporal(TemporalType.DATE)
    private Date fechaNacimiento;

    @NotBlank(message = "usuarioDni es obligatorio")
    private String usuarioDni;  // Se envía solo el DNI del dueño, no el objeto completo.
}