package com.example.clinica.dtos;

import java.text.SimpleDateFormat;

import com.example.clinica.entities.Notificacion;

public class GetNotificacionDto {

    private Long id;
    private String mensaje;
    private String fechaEnvio;
    private Long citaId;
    @SuppressWarnings("unused")
    private Boolean leida;
    public GetNotificacionDto(Long id, String mensaje, String fechaEnvio, Long citaId) {
        this.id = id;
        this.mensaje = mensaje;
        this.fechaEnvio = fechaEnvio;
        this.citaId = citaId;
    }
    
    public GetNotificacionDto(Notificacion notificacion) {
    this.id = notificacion.getId();
    this.mensaje = notificacion.getMensaje();
    this.fechaEnvio = new SimpleDateFormat("dd/MM/yyyy").format(notificacion.getFechaEnvio());
    this.citaId = notificacion.getCita().getId();
    }

    // Getters y setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(String fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }

    public Long getCitaId() {
        return citaId;
    }

    public void setCitaId(Long citaId) {
        this.citaId = citaId;
    }

    public void setLeida(boolean leida) {
        this.leida = leida;
    }
    
}
