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

import com.example.clinica.dtos.CreateServicioDto;
import com.example.clinica.dtos.GetServicioDto;
import com.example.clinica.entities.Servicio;
import com.example.clinica.services.ServicioService;

@RestController
@RequestMapping("/servicios")
public class ServicioController {

    private final ServicioService servicioService;

    // Constructor que inyecta el servicio
    public ServicioController(ServicioService servicioService) {
        this.servicioService = servicioService;
    }

    // Obtener todos los servicios
    @GetMapping
    public List<GetServicioDto> getAllServicios() {
        return servicioService.getAllServicios();
    }

    // Obtener un servicio por ID
    @GetMapping("/{id}")
    public ResponseEntity<GetServicioDto> getServicioById(@PathVariable Long id) {
        return servicioService.getServicioById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Crear un nuevo servicio
    @PostMapping
    public ResponseEntity<GetServicioDto> createServicio(@RequestBody CreateServicioDto dto) {
        Servicio nuevoServicio = servicioService.createServicio(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(servicioService.getServicioById(nuevoServicio.getId()).orElse(null));
    }

    // Actualizar un servicio
    @PutMapping("/{id}")
    public ResponseEntity<GetServicioDto> updateServicio(@PathVariable Long id, @RequestBody CreateServicioDto dto) {
        return servicioService.updateServicio(id, dto)
                .map(servicio -> ResponseEntity.ok(servicioService.getServicioById(servicio.getId()).orElse(null)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Eliminar un servicio
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteServicio(@PathVariable Long id) {
        if (servicioService.deleteServicio(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}


