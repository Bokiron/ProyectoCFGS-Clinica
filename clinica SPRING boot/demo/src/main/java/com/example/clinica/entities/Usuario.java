package com.example.clinica.entities;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "usuarios")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {

    @Id
    private String dni; // Clave primaria
    private String nombre;
    private String apellidos;
    private String email;
    private String telefono;
    private String contrasena;

    @Enumerated(EnumType.STRING)
    private Rol rol;
    public enum Rol {
        USUARIO, ADMIN
    }
    // Constructor sin contraseña para evitar exponerla en DTOs
    public Usuario(String dni, String nombre, String apellidos, String email, String telefono, Rol rol) {
        this.dni = dni;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.email = email;
        this.telefono = telefono;
        this.rol = rol;
    }
}
