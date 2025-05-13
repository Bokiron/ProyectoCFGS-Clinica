package com.example.clinica.dtos;

import lombok.Data;

@Data
public class LoginRequestDto {
    private String dniOrEmail;
    private String contrasena;
}
