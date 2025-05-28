package com.example.clinica.dtos;

import java.util.Date;
import com.example.clinica.entities.Mascota.Sexo;
import com.example.clinica.entities.Mascota.Tamano;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class GetMascotaDto {
    private Long id;
    private String nombre;
    private String especie;
    private String raza;
    private Date fechaNacimiento;
    private Tamano tamano;
    private Double peso;
    private Sexo sexo;
    private String usuarioDni;
    private String imagenUrl;
}
