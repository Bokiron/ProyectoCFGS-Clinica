package com.example.clinica.controllers;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.clinica.dtos.CreateUsuarioDto;
import com.example.clinica.dtos.GetUsuarioDto;
import com.example.clinica.entities.Usuario;
import com.example.clinica.services.UsuarioService;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService usuarioService;

    // Constructor que inyecta el servicio
    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
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

    // Eliminar un usuario
    @DeleteMapping("/{dni}")
    public ResponseEntity<Void> deleteUsuario(@PathVariable String dni) {
        if (usuarioService.deleteUsuario(dni)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}

