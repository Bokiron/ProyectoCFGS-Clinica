package com.example.clinica.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonFormat;

@Entity
@Table(name = "citas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cita {

    public enum Espacio {
        CONSULTA, PELUQUERIA
    }

    public enum EstadoCita {
        CONFIRMADA, CANCELADA
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "fechaCita es obligatoria")
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
    private LocalDateTime fechaCita; // Almacena fecha y hora en la BD

    @Enumerated(EnumType.STRING)
    @NotNull(message = "El espacio es obligatorio")
    private Espacio espacio;

    @NotNull(message = "El motivo es obligatorio")
    private String motivo;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "El estado es obligatorio")
    private EstadoCita estado = EstadoCita.CONFIRMADA;

    @ManyToOne
    @JoinColumn(name = "mascota_id", nullable = false)
    private Mascota mascota;

    @ManyToOne
    @JoinColumn(name = "usuario_dni", nullable = false)
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "servicio_id", nullable = false)
    private Servicio servicio;

}