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

import com.example.clinica.dtos.CreateCitaDto;
import com.example.clinica.dtos.GetCitaDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;
import com.example.clinica.repositories.MascotaRepository;
import com.example.clinica.repositories.ServicioRepository;
import com.example.clinica.services.CitaService;

@RestController // Indica que esta clase es un controlador REST
@RequestMapping("/citas") // Define la ruta base para todas las peticiones relacionadas con citas
public class CitaController {

    private final CitaService citaService;
    private final MascotaRepository mascotaRepository;
    private final ServicioRepository servicioRepository;

    // Constructor que inyecta los servicios y repositorios necesarios
    public CitaController(CitaService citaService, MascotaRepository mascotaRepository, ServicioRepository servicioRepository) {
        this.citaService = citaService;
        this.mascotaRepository = mascotaRepository;
        this.servicioRepository = servicioRepository;
    }

    @GetMapping // Maneja solicitudes GET para obtener todas las citas
    public List<GetCitaDto> getAllCitas() {
        return citaService.getAllCitas(); // Llama al servicio para obtener y mapear todas las citas
    }

    @GetMapping("/{id}") // Maneja solicitudes GET para obtener una cita por su ID
    public ResponseEntity<GetCitaDto> getCitaById(@PathVariable Long id) {
        return citaService.getCitaById(id) // Busca la cita por ID
                .map(ResponseEntity::ok) // Si se encuentra, retorna 200 OK con la cita
                .orElseGet(() -> ResponseEntity.notFound().build()); // Si no se encuentra, retorna 404
    }

    @PostMapping // Maneja solicitudes POST para crear una nueva cita
    public ResponseEntity<GetCitaDto> createCita(@RequestBody CreateCitaDto dto) {
        // Busca la mascota y el servicio en la base de datos
        Mascota mascota = mascotaRepository.findById(dto.getMascotaId()).orElse(null);
        Servicio servicio = servicioRepository.findById(dto.getServicioId()).orElse(null);
        
        if (mascota == null || servicio == null) { // Valida que existan
            return ResponseEntity.badRequest().build(); // Retorna 400 Bad Request si no existen
        }

        // Crea la cita con la mascota y servicio recuperados
        Cita nuevaCita = citaService.createCita(dto, mascota, servicio);
        return ResponseEntity.status(HttpStatus.CREATED) // Retorna 201 Created con la nueva cita
                .body(citaService.getCitaById(nuevaCita.getId()).orElse(null));
    }

    @PutMapping("/{id}") // Maneja solicitudes PUT para actualizar completamente una cita
    public ResponseEntity<GetCitaDto> updateCita(@PathVariable Long id, @RequestBody CreateCitaDto dto) {
        // Busca la mascota y el servicio en la base de datos
        Mascota mascota = mascotaRepository.findById(dto.getMascotaId()).orElse(null);
        Servicio servicio = servicioRepository.findById(dto.getServicioId()).orElse(null);
        
        if (mascota == null || servicio == null) { // Valida que existan
            return ResponseEntity.badRequest().build(); // Retorna 400 Bad Request si no existen
        }

        return citaService.updateCita(id, dto, mascota, servicio) // Llama al servicio para actualizar
                .map(cita -> ResponseEntity.ok(citaService.getCitaById(cita.getId()).orElse(null))) // Retorna 200 OK con la cita actualizada
                .orElseGet(() -> ResponseEntity.notFound().build()); // Retorna 404 si no se encuentra la cita
    }

    @DeleteMapping("/{id}") // Maneja solicitudes DELETE para eliminar una cita por su ID
    public ResponseEntity<Void> deleteCita(@PathVariable Long id) {
        if (citaService.deleteCita(id)) { // Si la cita existe y se elimina
            return ResponseEntity.noContent().build(); // Retorna 204 No Content
        }
        return ResponseEntity.notFound().build(); // Retorna 404 si no se encuentra la cita
    }
}

