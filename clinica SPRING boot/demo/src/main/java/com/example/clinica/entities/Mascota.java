package com.example.clinica.entities;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Entity
@Table(name = "mascotas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Mascota {

    public enum Sexo {
        MACHO, 
        HEMBRA
    }

    public enum Tamano {
        PEQUENO,
        MEDIANO,
        GRANDE
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;
    private String especie;
    private String raza;

    @Column(nullable = true) // Permite null si la mascota no tiene imagen
    private String imagenUrl; // Ruta relativa (ej: "uploads/mascotas/1.jpg")

    @NotNull(message = "fechaNacimiento es obligatoria")
    @JsonFormat(pattern = "dd/MM/yyyy")
    @Temporal(TemporalType.DATE)
    private Date fechaNacimiento;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Tamano tamano;

    @NotNull(message = "peso es obligatorio")
    private Double peso;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Sexo sexo;

    @ManyToOne
    @JoinColumn(name = "usuario_dni", nullable = false)
    private Usuario usuario;
}
