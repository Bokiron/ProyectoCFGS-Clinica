package com.example.clinica.controllers;

import java.util.List;
import java.util.Optional;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.example.clinica.dtos.CreateUsuarioDto;
import com.example.clinica.dtos.GetUsuarioDto;
import com.example.clinica.dtos.LoginRequestDto;
import com.example.clinica.dtos.UpdateUsuarioRolDto;
import com.example.clinica.entities.Usuario;
import com.example.clinica.mappers.UsuarioMapper;
import com.example.clinica.services.UsuarioService;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final UsuarioMapper usuarioMapper;
    // Constructor que inyecta el servicio
    public UsuarioController(UsuarioService usuarioService, UsuarioMapper usuarioMapper) {
        this.usuarioService = usuarioService;
        this.usuarioMapper = usuarioMapper;
    }

    // Obtener todos los usuarios
    @GetMapping
    public List<GetUsuarioDto> getAllUsuarios() {
        return usuarioService.getAllUsuarios();
    }

    // Obtener un usuario por ID
    @GetMapping("/{dni}")
    public ResponseEntity<GetUsuarioDto> getUsuarioById(@PathVariable String dni) {
        return usuarioService.getUsuarioByDni(dni)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
    // Obtener usuario por DNI o email usando un parámetro de consulta. Ruta localhost:8080/usuarios/buscar?dniOrEmail=1@1.com
    @GetMapping("/buscar")
    public ResponseEntity<GetUsuarioDto> getUsuarioByDniOrEmail(@RequestParam String dni) {
        return usuarioService.getUsuarioByDni(dni)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Crear un nuevo usuario
    @PostMapping
    public ResponseEntity<GetUsuarioDto> createUsuario(@RequestBody CreateUsuarioDto dto) {
        Usuario nuevoUsuario = usuarioService.createUsuario(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(usuarioService.getUsuarioByDni(nuevoUsuario.getDni()).orElse(null));
    }

    // Actualizar un usuario
    @PutMapping("/{dni}")
    public ResponseEntity<GetUsuarioDto> updateUsuario(@PathVariable String dni, @RequestBody CreateUsuarioDto dto) {
        return usuarioService.updateUsuario(dni, dto)
                .map(usuario -> ResponseEntity.ok(usuarioService.getUsuarioByDni(dni).orElse(null)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
    //actualizar rol de un usuario, solo para que puedan admins 
    @PutMapping("/{dni}/rol")
    @PreAuthorize("hasRole('ADMIN')")//comprueba que el usuario tenga el rol admin, mediante la dependencia spring security
    public ResponseEntity<GetUsuarioDto> updateUsuarioRol(
            @PathVariable String dni,
            @RequestBody UpdateUsuarioRolDto dto) {
        return usuarioService.updateUsuarioRol(dni, dto.getRol())
            .map(usuario -> ResponseEntity.ok(usuarioMapper.toGetUsuarioDto(usuario)))
            .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Eliminar un usuario
    @DeleteMapping("/{dni}")
    public ResponseEntity<Void> deleteUsuario(@PathVariable String dni) {
        if (usuarioService.deleteUsuario(dni)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
    //Ruta para comprobar el logueo de un usuario
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequestDto loginDto) {
        if (usuarioService.login(loginDto.getDni(), loginDto.getContrasena())) {
            // Opcional: devolver info del usuario o token
            return ResponseEntity.ok().body("Login correcto");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Credenciales incorrectas");
        }
    }

}

