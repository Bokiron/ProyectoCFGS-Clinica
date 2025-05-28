package com.example.clinica.dtos;

import java.time.LocalDate;
import com.example.clinica.entities.Cita.Espacio;
import com.example.clinica.entities.Cita.EstadoCita;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UpdateCitaDto {

    private LocalDate fecha;
    private String hora;
    private Espacio espacio;
    private String motivo;
    private EstadoCita estado;
    private Long mascotaId;
    private String usuarioDni;
    private Long servicioId;

}