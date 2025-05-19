package com.example.clinica.dtos;

import java.time.LocalDate;
import java.time.LocalTime;
import com.fasterxml.jackson.annotation.JsonFormat;
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
public class CreateCitaDto {
    private Long id;

    @NotNull(message = "La fecha de la cita es obligatoria")
    @JsonFormat(pattern = "dd/MM/yyyy")
    private LocalDate fecha;  // Solo la fecha

    @NotNull(message = "La hora de la cita es obligatoria")
    @JsonFormat(pattern = "HH:mm")
    private LocalTime hora;   // Solo la hora

    @NotNull(message = "El espacio es obligatorio")
    private String espacio;

    private String motivo;

    @NotNull(message = "El estado es obligatorio")
    private String estado;

    @NotNull(message = "id de la mascota es obligatorio")
    private Long mascotaId;

    @NotNull(message = "El dni del usuario es obligatorio")
    private String usuarioDni;

    @NotNull(message = "id del servicio es obligatorio")
    private Long servicioId;
}
