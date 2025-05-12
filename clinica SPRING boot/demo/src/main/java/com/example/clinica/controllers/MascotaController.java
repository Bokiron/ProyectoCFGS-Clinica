package com.example.clinica.controllers;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.example.clinica.dtos.CreateMascotaDto;
import com.example.clinica.dtos.GetMascotaDto;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Usuario;
import com.example.clinica.repositories.UsuarioRepository;
import com.example.clinica.services.MascotaService;

@RestController
@RequestMapping("/mascotas")
public class MascotaController {

    private final MascotaService mascotaService;
    private final UsuarioRepository usuarioRepository;
    public MascotaController(MascotaService mascotaService, UsuarioRepository usuarioRepository) {
        this.mascotaService = mascotaService;
        this.usuarioRepository = usuarioRepository;
    }

    // Obtener todas las mascotas
    @GetMapping
    public List<GetMascotaDto> getAllMascotas() {
        return mascotaService.getAllMascotas();
    }

    // Obtener una mascota por ID
    @GetMapping("/{id}")
    public ResponseEntity<GetMascotaDto> getMascotaById(@PathVariable Long id) {
        return mascotaService.getMascotaById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Crear una nueva mascota
    @PostMapping
    public ResponseEntity<GetMascotaDto> createMascota(@RequestBody CreateMascotaDto dto) {
        Usuario usuario = usuarioRepository.findByDni(dto.getUsuarioDni())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));
        Mascota nuevaMascota = mascotaService.createMascota(dto, usuario);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(mascotaService.getMascotaById(nuevaMascota.getId()).orElse(null));
    }

    // Actualizar parcialmente una mascota (PATCH)
    @PatchMapping("/{id}")
    public ResponseEntity<GetMascotaDto> updateMascota(@PathVariable Long id, @RequestBody CreateMascotaDto dto) {
        return mascotaService.updateMascota(id, dto)
                .map(mascota -> ResponseEntity.ok(mascotaService.getMascotaById(mascota.getId()).orElse(null)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Eliminar una mascota
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMascota(@PathVariable Long id) {
        if (mascotaService.deleteMascota(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
