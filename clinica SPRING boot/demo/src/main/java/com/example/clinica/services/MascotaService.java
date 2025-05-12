package com.example.clinica.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.clinica.dtos.CreateMascotaDto;
import com.example.clinica.dtos.GetMascotaDto;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Usuario;
import com.example.clinica.mappers.MascotaMapper;
import com.example.clinica.repositories.MascotaRepository;

@Service
public class MascotaService {

    private final MascotaRepository mascotaRepository;
    private final MascotaMapper mascotaMapper;

    public MascotaService(MascotaRepository mascotaRepository, MascotaMapper mascotaMapper) {
        this.mascotaRepository = mascotaRepository;
        this.mascotaMapper = mascotaMapper;
    }

    // Obtener todas las mascotas
    public List<GetMascotaDto> getAllMascotas() {
        return mascotaRepository.findAll()
                .stream()
                .map(mascotaMapper::toGetMascotaDto)
                .collect(Collectors.toList());
    }

    // Obtener una mascota por ID
    public Optional<GetMascotaDto> getMascotaById(Long id) {
        return mascotaRepository.findById(id).map(mascotaMapper::toGetMascotaDto);
    }

    // Crear una nueva mascota
    public Mascota createMascota(CreateMascotaDto dto, Usuario usuario) {
        Mascota nuevaMascota = mascotaMapper.toMascota(dto, usuario);
        return mascotaRepository.save(nuevaMascota);
    }

    // Actualizar parcialmente una mascota
    public Optional<Mascota> updateMascota(Long id, CreateMascotaDto dto) {
        return mascotaRepository.findById(id).map(mascota -> {
            if (dto.getNombre() != null) mascota.setNombre(dto.getNombre());
            if (dto.getEspecie() != null) mascota.setEspecie(dto.getEspecie());
            if (dto.getRaza() != null) mascota.setRaza(dto.getRaza());
            return mascotaRepository.save(mascota);
        });
    }

    // Eliminar una mascota
    public boolean deleteMascota(Long id) {
        if (mascotaRepository.existsById(id)) {
            mascotaRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
