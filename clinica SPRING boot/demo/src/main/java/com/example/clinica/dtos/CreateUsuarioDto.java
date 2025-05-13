package com.example.clinica.dtos;
import jakarta.validation.constraints.NotBlank;
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
public class CreateUsuarioDto {
    @NotBlank(message = "dni es obligatorio")
    private String dni;
    @NotBlank(message = "nombre es obligatorio")
    private String nombre;
    @NotBlank(message = "apellidos es obligatorio")
    private String apellidos;
    @NotBlank(message = "email es obligatorio")
    private String email;
    @NotBlank(message = "telefono es obligatorio")
    private String telefono;
    @NotBlank(message = "contraseña es obligatoria") // Campo nuevo
    private String contrasena; 

    //ausencia del campo 'Rol' para que no pueda ser enviado por el cliente
}
