package com.example.clinica.services;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import com.example.clinica.dtos.CreateCitaDto;
import com.example.clinica.dtos.GetCitaDto;
import com.example.clinica.dtos.UpdateCitaDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Servicio;
import com.example.clinica.entities.Usuario;
import com.example.clinica.exceptions.CitaSolapadaException;
import com.example.clinica.mappers.CitaMapper;
import com.example.clinica.repositories.CitaRepository;
import com.example.clinica.repositories.MascotaRepository;
import com.example.clinica.repositories.ServicioRepository;
import com.example.clinica.repositories.UsuarioRepository;

@Service // Indica que esta clase es un servicio de Spring
public class CitaService {

    private final CitaRepository citaRepository;
    private final UsuarioRepository usuarioRepository;
    private final MascotaRepository mascotaRepository;
    private final ServicioRepository servicioRepository;
    private final CitaMapper citaMapper;

    // Constructor para intorducir el repositorio de citas y el mapper
    public CitaService(CitaRepository citaRepository, CitaMapper citaMapper, MascotaRepository mascotaRepository, UsuarioRepository usuarioRepository, ServicioRepository servicioRepository) {
        this.citaRepository = citaRepository;
        this.citaMapper = citaMapper;
        this.servicioRepository = servicioRepository;
        this.usuarioRepository = usuarioRepository;
        this.mascotaRepository = mascotaRepository;
    }

    // Obtiene todas las citas de la base de datos y las convierte a DTOs
    public List<GetCitaDto> getAllCitas() {
        return citaRepository.findAll()
                .stream()
                .map(citaMapper::toGetCitaDto) // Convierte cada entidad Cita a GetCitaDto
                .collect(Collectors.toList()); // Retorna la lista de DTOs
    }

    // Obtiene una cita por ID y la convierte a DTO
    public Optional<GetCitaDto> getCitaById(Long id) {
        return citaRepository.findById(id).map(citaMapper::toGetCitaDto);
    }

    public List<GetCitaDto> getCitasByUsuario(String dni) {
        return citaRepository.findByUsuarioDniOrderByFechaCitaAsc(dni)
            .stream()
            .map(citaMapper::toGetCitaDto)
            .collect(Collectors.toList());
    }
    //obtener citas proximas confirmadas de un usuario
    public List<GetCitaDto> getCitasProximasConfirmadasByUsuario(String dni) {
        List<Cita> citas = citaRepository.findByUsuarioDniAndEstadoAndFechaCitaAfterOrderByFechaCitaAsc(
            dni, Cita.EstadoCita.CONFIRMADA, LocalDateTime.now()
        );
        return citas.stream().map(citaMapper::toGetCitaDto).collect(Collectors.toList());
    }

    public List<GetCitaDto> getHistorialCitasByUsuario(String dni) {
        List<Cita> citas = citaRepository.findHistorialByUsuario(dni, LocalDateTime.now());
        return citas.stream().map(citaMapper::toGetCitaDto).collect(Collectors.toList());
    }


    // Crea una nueva cita con los datos proporcionados
    public Cita createCita(CreateCitaDto dto, Mascota mascota, Servicio servicio, Usuario usuario) {
        LocalDateTime fechaCita = LocalDateTime.of(dto.getFecha(), dto.getHora());
        Cita.Espacio espacio = Cita.Espacio.valueOf(dto.getEspacio().toUpperCase());
        
        // Valida que no haya una cita CONFIRMADA en el mismo espacio y en la misma fecha
        if (citaRepository.existsByEspacioAndEstadoAndFechaCita(
            espacio, Cita.EstadoCita.CONFIRMADA, fechaCita
        )) {
            throw new CitaSolapadaException("Ya existe una cita confirmada en ese espacio, fecha y hora.");
        }

        Cita nuevaCita = citaMapper.toCita(dto, mascota, servicio, usuario);
        return citaRepository.save(nuevaCita);
    }

    // Actualiza completamente una cita existente
    public Optional<Cita> updateCita(Long id, CreateCitaDto dto, Mascota mascota, Servicio servicio) {
        return citaRepository.findById(id).map(cita -> { // Busca la cita por ID
            // Actualiza los datos de la cita
            cita.setFechaCita(LocalDateTime.of(dto.getFecha(), dto.getHora()));
            cita.setMotivo(dto.getMotivo());
            cita.setMascota(mascota);
            cita.setServicio(servicio);
            return citaRepository.save(cita); // Guarda los cambios en la base de datos
        });
    }
    //actualizar cita
    public Optional<Cita> updateCitaParcial(Long id, UpdateCitaDto dto) {
        return citaRepository.findById(id).map(cita -> {
            if (dto.getFecha() != null) cita.setFechaCita(LocalDateTime.of(dto.getFecha(), LocalTime.parse(dto.getHora())));
            if (dto.getHora() != null) cita.setFechaCita(LocalDateTime.of(cita.getFechaCita().toLocalDate(), LocalTime.parse(dto.getHora())));
            if (dto.getEspacio() != null) cita.setEspacio(dto.getEspacio());
            if (dto.getMotivo() != null) cita.setMotivo(dto.getMotivo());
            if (dto.getEstado() != null) cita.setEstado(dto.getEstado());
            // Actualiza mascota, usuario y servicio si se envía el ID
            if (dto.getMascotaId() != null) {
                mascotaRepository.findById(dto.getMascotaId()).ifPresent(cita::setMascota);
            }
            if (dto.getUsuarioDni() != null) {
                usuarioRepository.findById(dto.getUsuarioDni()).ifPresent(cita::setUsuario);
            }
            if (dto.getServicioId() != null) {
                servicioRepository.findById(dto.getServicioId()).ifPresent(cita::setServicio);
            }
            return citaRepository.save(cita);
        });
    }


    // Elimina una cita si existe
    public boolean deleteCita(Long id) {
        if (citaRepository.existsById(id)) { // Verifica si la cita existe
            citaRepository.deleteById(id); // Elimina la cita
            return true;
        }
        return false; // Retorna false si la cita no existía
    }
}

