package com.example.clinica.mappers;

import java.text.SimpleDateFormat;

import org.springframework.stereotype.Component;

import com.example.clinica.dtos.CreateNotificacionDto;
import com.example.clinica.dtos.GetNotificacionDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Notificacion;

@Component
public class NotificacionMapper {

    private final SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    public GetNotificacionDto toGetNotificacionDto(Notificacion notificacion) {
        return new GetNotificacionDto(
                notificacion.getId(),
                notificacion.getMensaje(),
                dateFormat.format(notificacion.getFechaEnvio()),
                notificacion.getCita().getId()
        );
    }

    public Notificacion toNotificacion(CreateNotificacionDto dto, Cita cita) {
        Notificacion notificacion = new Notificacion();
        notificacion.setMensaje(dto.getMensaje());
        notificacion.setFechaEnvio(dto.getFechaEnvio());
        notificacion.setCita(cita); // correcto ahora
        notificacion.setLeida(false); // si añadiste ese campo
        return notificacion;
    }
}
