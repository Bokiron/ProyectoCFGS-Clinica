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

import com.example.clinica.dtos.CreateNotificacionDto;
import com.example.clinica.dtos.GetNotificacionDto;
import com.example.clinica.entities.Notificacion;
import com.example.clinica.services.NotificacionService;

@RestController
@RequestMapping("/notificaciones")
public class NotificacionController {

    private final NotificacionService notificacionService;

    public NotificacionController(NotificacionService notificacionService) {
        this.notificacionService = notificacionService;
    }

    // Obtener todas las notificaciones
    @GetMapping
    public List<GetNotificacionDto> getAllNotificaciones() {
        return notificacionService.getAllNotificaciones();
    }

    // Obtener notificaciones de un usuario específico
    @GetMapping("/usuario/{usuarioDni}")
    public List<GetNotificacionDto> getNotificacionesByUsuario(@PathVariable String usuarioDni) {
        return notificacionService.getNotificacionesByUsuario(usuarioDni);
    }

    // Crear una nueva notificación
    @PostMapping
    public ResponseEntity<GetNotificacionDto> createNotificacion(@RequestBody CreateNotificacionDto dto) {
        Notificacion notificacion = notificacionService.createNotificacion(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(new GetNotificacionDto(notificacion));
    }

    // Eliminar una notificación
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNotificacion(@PathVariable Long id) {
        if (notificacionService.deleteNotificacion(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    // Marcar una notificación como leída
    @PatchMapping("/{id}/marcar-leida")
    public ResponseEntity<GetNotificacionDto> markAsRead(@PathVariable Long id) {
        return notificacionService.markAsRead(id)
                .map(notificacion -> ResponseEntity.ok(new GetNotificacionDto(notificacion)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
