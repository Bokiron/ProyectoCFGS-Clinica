package com.example.clinica.services;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Path;
import java.util.UUID;
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

    // Define la carpeta donde se guardarán las imágenes (ajusta la ruta según tu SO)
    private static final String UPLOAD_DIR = "C:/Users/david/Desktop/2DAM/PROYECTO-CFGS/Proyecto - Codigo/imagenesMascotas/";
    //metodo para guardar la imagen
    public String guardarImagen(Long mascotaId, MultipartFile imagen) throws IOException {
        // Crea la carpeta si no existe
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Genera un nombre único para el archivo
        String extension = imagen.getOriginalFilename().split("\\.")[1];
        String nombreArchivo = mascotaId + "_" + UUID.randomUUID() + "." + extension;

        // Guarda el archivo
        Path filePath = uploadPath.resolve(nombreArchivo);
        Files.copy(imagen.getInputStream(), filePath);

        // Retorna la ruta relativa (ej: "uploads/mascotas/1_abc123.jpg")
        return nombreArchivo;
    }

    // Actualizar parcialmente una mascota
    public Optional<Mascota> updateMascota(Long id, CreateMascotaDto dto) {
        return mascotaRepository.findById(id).map(mascota -> {
            if (dto.getNombre() != null) mascota.setNombre(dto.getNombre());
            if (dto.getEspecie() != null) mascota.setEspecie(dto.getEspecie());
            if (dto.getRaza() != null) mascota.setRaza(dto.getRaza());
            if (dto.getTamano() != null) mascota.setTamano(dto.getTamano());
            if (dto.getPeso() != null) mascota.setPeso(dto.getPeso());
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
