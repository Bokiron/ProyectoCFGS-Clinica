package com.example.clinica.controllers;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.example.clinica.dtos.CreateCitaDto;
import com.example.clinica.dtos.GetCitaDto;
import com.example.clinica.dtos.UpdateCitaDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;
import com.example.clinica.entities.Usuario;
import com.example.clinica.repositories.CitaRepository;
import com.example.clinica.repositories.MascotaRepository;
import com.example.clinica.repositories.ServicioRepository;
import com.example.clinica.repositories.UsuarioRepository;
import com.example.clinica.services.CitaService;

@RestController // Indica que esta clase es un controlador REST
@RequestMapping("/citas") // Define la ruta base para todas las peticiones relacionadas con citas
public class CitaController {

    private final CitaService citaService;
    private final MascotaRepository mascotaRepository;
    private final ServicioRepository servicioRepository;
    private final UsuarioRepository usuarioRepository;
    private final CitaRepository citaRepository;
    // Constructor que inyecta los servicios y repositorios necesarios
    public CitaController(CitaService citaService, MascotaRepository mascotaRepository, ServicioRepository servicioRepository, UsuarioRepository usuarioRepository, CitaRepository citaRepository) {
        this.citaService = citaService;
        this.mascotaRepository = mascotaRepository;
        this.servicioRepository = servicioRepository;
        this.usuarioRepository = usuarioRepository;
        this.citaRepository = citaRepository;
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

    @GetMapping("/usuario/{dni}")
    public List<GetCitaDto> getCitasByUsuario(@PathVariable String dni) {
        return citaService.getCitasByUsuario(dni);
    }

    //obtiene las horas ocupadas por citas confirmadas
    @GetMapping("/ocupadas")
    public List<String> getHorasOcupadas(
        @RequestParam String fecha,
        @RequestParam String espacio
    ) {
        LocalDate dia = LocalDate.parse(fecha, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        LocalDateTime start = dia.atStartOfDay();
        LocalDateTime end = dia.atTime(LocalTime.MAX);
        Cita.Espacio espacioEnum = Cita.Espacio.valueOf(espacio.trim().toUpperCase());
        List<Cita> citas = citaRepository.findByEspacioAndEstadoAndFechaCitaBetween(
            espacioEnum, Cita.EstadoCita.CONFIRMADA, start, end
        );
        return citas.stream()
            .map(c -> c.getFechaCita().toLocalTime().toString().substring(0,5))
            .toList();
    }

    //endpoint para obtener las proximas citas del usuario
    @GetMapping("/usuario/{dni}/proximas")
    public List<GetCitaDto> getCitasProximasConfirmadasByUsuario(@PathVariable String dni) {
        return citaService.getCitasProximasConfirmadasByUsuario(dni);
    }
    //endpoint para obtener el historial de citas de un usuario
    @GetMapping("/usuario/{dni}/historial")
    public List<GetCitaDto> getHistorialCitasByUsuario(@PathVariable String dni) {
        return citaService.getHistorialCitasByUsuario(dni);
    }


    @PostMapping // Maneja solicitudes POST para crear una nueva cita
    public ResponseEntity<GetCitaDto> createCita(@RequestBody CreateCitaDto dto) {
        // Busca la mascota y el servicio en la base de datos
        Mascota mascota = mascotaRepository.findById(dto.getMascotaId()).orElse(null);
        Servicio servicio = servicioRepository.findById(dto.getServicioId()).orElse(null);
        Usuario usuario = usuarioRepository.findByDni(dto.getUsuarioDni()).orElse(null);
        if (mascota == null || servicio == null) { // Valida que existan
            return ResponseEntity.badRequest().build(); // Retorna 400 Bad Request si no existen
        }

        // Crea la cita con la mascota y servicio recuperados
        Cita nuevaCita = citaService.createCita(dto, mascota, servicio, usuario);
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

    @PatchMapping("/{id}")
    public ResponseEntity<GetCitaDto> updateCitaParcial(
        @PathVariable Long id,
        @RequestBody UpdateCitaDto dto
    ) {
        return citaService.updateCitaParcial(id, dto)
            .map(cita -> ResponseEntity.ok(citaService.getCitaById(cita.getId()).orElse(null)))
            .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}") // Maneja solicitudes DELETE para eliminar una cita por su ID
    public ResponseEntity<Void> deleteCita(@PathVariable Long id) {
        if (citaService.deleteCita(id)) { // Si la cita existe y se elimina
            return ResponseEntity.noContent().build(); // Retorna 204 No Content
        }
        return ResponseEntity.notFound().build(); // Retorna 404 si no se encuentra la cita
    }
}

