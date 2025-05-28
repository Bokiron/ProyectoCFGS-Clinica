package com.example.clinica.dtos;

import java.time.LocalDate;
import java.time.LocalTime;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;
import com.example.clinica.entities.Usuario;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class GetCitaDto {
    private Long id;
    private LocalDate fecha;  //almacena solo la fecha
    private LocalTime hora;   //almacena solo la hora
    private String espacio;
    private String motivo;
    private String estado;
    private Mascota mascota;
    private Usuario usuario;
    private Servicio servicio;
}
