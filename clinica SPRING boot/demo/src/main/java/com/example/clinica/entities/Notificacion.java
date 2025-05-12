package com.example.clinica.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

@Entity
@Table(name = "notificaciones")
@Data
@NoArgsConstructor//Genera automáticamente un constructor sin argumentos.
@AllArgsConstructor //Genera un constructor con todos los argumentos de la clase.
public class Notificacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String mensaje;

    @NotNull(message = "fechaEnvio es obligatoria")
    @JsonFormat(pattern = "dd/MM/yyyy")
    @Temporal(TemporalType.DATE)
    private Date fechaEnvio;

    @ManyToOne
    @JoinColumn(name = "cita_id", nullable = false)
    private Cita cita;

    @Column(nullable = false)
    private boolean leida = false;
}
