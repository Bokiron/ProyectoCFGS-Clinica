package com.example.clinica.dtos;

import lombok.*;
import java.util.List;

@Data
public class GetCarritoDto {
    private Long id;
    private String usuarioDni;
    private List<GetLineaCarritoDto> lineas;
}

