package com.example.clinica.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import com.example.clinica.dtos.CreateServicioDto;
import com.example.clinica.dtos.GetServicioDto;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Cita.Espacio;
import com.example.clinica.entities.Servicio;
import com.example.clinica.mappers.ServicioMapper;
import com.example.clinica.repositories.CitaRepository;
import com.example.clinica.repositories.ServicioRepository;

@Service
public class ServicioService {

    private final ServicioRepository servicioRepository;
    private final CitaRepository citaRepository;
    private final ServicioMapper servicioMapper;

    // Constructor que inyecta el repositorio y el mapper
    public ServicioService(ServicioRepository servicioRepository, ServicioMapper servicioMapper, CitaRepository citaRepository) {
        this.servicioRepository = servicioRepository;
        this.servicioMapper = servicioMapper;
        this.citaRepository = citaRepository;
    }

    // Obtener todos los servicios
    public List<GetServicioDto> getAllServicios() {
        return servicioRepository.findAll()
                .stream()
                .map(servicioMapper::toGetServicioDto)
                .collect(Collectors.toList());
    }

    // Obtener un servicio por ID
    public Optional<GetServicioDto> getServicioById(Long id) {
        return servicioRepository.findById(id).map(servicioMapper::toGetServicioDto);
    }

    //obtener servicios por su espacio
    public List<GetServicioDto> getServiciosByEspacio(Espacio espacio) {
    return servicioRepository.findByEspacioServicio(espacio)
        .stream()
        .map(servicioMapper::toGetServicioDto)
        .collect(Collectors.toList());
}

    // Crear un nuevo servicio
    public Servicio createServicio(CreateServicioDto dto) {
        Servicio nuevoServicio = servicioMapper.toServicio(dto);
        return servicioRepository.save(nuevoServicio);
    }

    // Actualizar un servicio
    public Optional<Servicio> updateServicio(Long id, CreateServicioDto dto) {
        return servicioRepository.findById(id).map(servicio -> {
            servicio.setNombre(dto.getNombre());
            servicio.setPrecio(dto.getPrecio());
            servicio.setEspacioServicio(dto.getEspacioServicio());
            return servicioRepository.save(servicio);
        });
    }

    // Eliminar un servicio
    public boolean deleteServicio(Long id) {
        Optional<Servicio> servicio = servicioRepository.findById(id);
        if (servicio.isPresent()) {
            // Verifica si hay citas asociadas al servicio
            List<Cita> citasAsociadas = citaRepository.findByServicio(servicio.get());
            if (!citasAsociadas.isEmpty()) {
                throw new IllegalStateException("No se puede eliminar el servicio porque tiene citas asociadas");
            }
            servicioRepository.deleteById(id);
            return true;
        }
        return false;
    }
}

