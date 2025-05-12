package com.example.clinica.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.clinica.dtos.CreateNotificacionDto;
import com.example.clinica.dtos.GetNotificacionDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Notificacion;
import com.example.clinica.mappers.NotificacionMapper;
import com.example.clinica.repositories.CitaRepository;
import com.example.clinica.repositories.NotificacionRepository;

@Service
public class NotificacionService {

    private final NotificacionRepository notificacionRepository;
    private final CitaRepository citaRepository;
    private final NotificacionMapper notificacionMapper;

    public NotificacionService(NotificacionRepository notificacionRepository, NotificacionMapper notificacionMapper, CitaRepository citaRepository) {
        this.notificacionRepository = notificacionRepository;
        this.notificacionMapper = notificacionMapper;
        this.citaRepository = citaRepository;
    }

    // Obtener todas las notificaciones
    public List<GetNotificacionDto> getAllNotificaciones() {
        return notificacionRepository.findAll()
                .stream()
                .map(notificacionMapper::toGetNotificacionDto)
                .collect(Collectors.toList());
    }

    // Obtener notificaciones de un usuario
    public List<GetNotificacionDto> getNotificacionesByUsuario(String usuarioId) {
        return notificacionRepository.findByCita_Mascota_Usuario_Dni(usuarioId)
                .stream()
                .map(notificacionMapper::toGetNotificacionDto)
                .collect(Collectors.toList());
    }

    // Crear una nueva notificación
    public Notificacion createNotificacion(CreateNotificacionDto dto) {
    Optional<Cita> citaOptional = citaRepository.findById(dto.getCitaId());
    if (citaOptional.isEmpty()) {
        throw new RuntimeException("Cita no encontrada con ID: " + dto.getCitaId());
    }

    Notificacion nuevaNotificacion = notificacionMapper.toNotificacion(dto, citaOptional.get());
    return notificacionRepository.save(nuevaNotificacion);
}

    // Eliminar una notificación
    public boolean deleteNotificacion(Long id) {
        if (notificacionRepository.existsById(id)) {
            notificacionRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // Marcar una notificación como leída
    public Optional<Notificacion> markAsRead(Long id) {
        return notificacionRepository.findById(id).map(notificacion -> {
            notificacion.setLeida(true);
            return notificacionRepository.save(notificacion);
        });
    }
}
