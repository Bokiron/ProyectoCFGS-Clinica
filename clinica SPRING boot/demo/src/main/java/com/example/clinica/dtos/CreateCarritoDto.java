package com.example.clinica.dtos;
import lombok.*;
import java.util.List;

@Data
public class CreateCarritoDto {
    private String usuarioDni;
    private List<CreateLineaCarritoDto> lineas;
}

