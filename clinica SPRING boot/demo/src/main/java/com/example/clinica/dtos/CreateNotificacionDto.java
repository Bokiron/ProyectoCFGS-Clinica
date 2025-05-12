package com.example.clinica.dtos;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class CreateNotificacionDto {

    private String mensaje;

    @JsonFormat(pattern = "dd/MM/yyyy")
    private Date fechaEnvio;

    private Long citaId;

    @SuppressWarnings("unused")
    private Boolean leida;

    public CreateNotificacionDto() {
    }

    public CreateNotificacionDto(String mensaje, Date fechaEnvio, Long citaId) {
        this.mensaje = mensaje;
        this.fechaEnvio = fechaEnvio;
        this.citaId = citaId;
    }

    // Getters y setters

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Date getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(Date fechaEnvio) {
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
