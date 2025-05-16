package com.example.clinica.controllers;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import com.example.clinica.dtos.CreateMascotaDto;
import com.example.clinica.dtos.GetMascotaDto;
import com.example.clinica.entities.Mascota;
import com.example.clinica.entities.Usuario;
import com.example.clinica.exceptions.MascotaNotFoundException;
import com.example.clinica.mappers.MascotaMapper;
import com.example.clinica.repositories.MascotaRepository;
import com.example.clinica.repositories.UsuarioRepository;
import com.example.clinica.services.MascotaService;

@RestController
@RequestMapping("/mascotas")
public class MascotaController {

    private final MascotaService mascotaService;
    private final UsuarioRepository usuarioRepository;
    private final MascotaRepository mascotaRepository;
        private final MascotaMapper mascotaMapper;

    public MascotaController(MascotaService mascotaService, UsuarioRepository usuarioRepository, MascotaRepository mascotaRepository, MascotaMapper mascotaMapper) {
        this.mascotaService = mascotaService;
        this.usuarioRepository = usuarioRepository;
        this.mascotaRepository = mascotaRepository;
        this.mascotaMapper = mascotaMapper;
    }

    // Obtener todas las mascotas
    @GetMapping
    public List<GetMascotaDto> getAllMascotas() {
        return mascotaService.getAllMascotas();
    }

    // Obtener una mascota por ID
    @GetMapping("/{id}")
    public ResponseEntity<GetMascotaDto> getMascotaById(@PathVariable Long id) {
        return mascotaService.getMascotaById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
    //endpoint para obtener una imagen
    @GetMapping("/{id}/imagen")
    public ResponseEntity<Resource> obtenerImagenMascota(@PathVariable Long id) {
        Mascota mascota = mascotaRepository.findById(id)
            .orElseThrow(() -> new MascotaNotFoundException(id));

        Path imagePath = Paths.get(mascota.getImagenUrl());
        Resource resource = (Resource) new FileSystemResource(imagePath.toFile());

        return ResponseEntity.ok()
            .contentType(MediaType.IMAGE_JPEG) // Ajusta según el tipo de imagen
            .body(resource);
    }
    //buscar las mascotas de un usuario a través de su email o dni
    @GetMapping("/buscar")
    public ResponseEntity<List<GetMascotaDto>> getMascotasByDniOrEmail(@RequestParam String dniOrEmail) {
        List<Mascota> mascotas = mascotaRepository.findByUsuarioDniOrEmail(dniOrEmail);
        if (mascotas.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        List<GetMascotaDto> mascotasDto = mascotas.stream()
            .map(mascotaMapper::toGetMascotaDto)
            .toList();
        return ResponseEntity.ok(mascotasDto);
    }

    // Crear una nueva mascota
    @PostMapping
    public ResponseEntity<GetMascotaDto> createMascota(@RequestBody CreateMascotaDto dto) {
        Usuario usuario = usuarioRepository.findByDni(dto.getUsuarioDni())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));
        Mascota nuevaMascota = mascotaService.createMascota(dto, usuario);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(mascotaService.getMascotaById(nuevaMascota.getId()).orElse(null));
    }

    //subir una imagen de la mascota
    @PostMapping(value = "/{id}/imagen", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<GetMascotaDto> subirImagenMascota(
            @PathVariable Long id,
            @RequestParam("imagen") MultipartFile imagen) throws IOException {

        // Verifica si la mascota existe
        Optional<Mascota> mascotaOpt = mascotaRepository.findById(id);
        if (mascotaOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        // Guarda la imagen y obtén la ruta
        String imagenUrl = mascotaService.guardarImagen(id, imagen);

        // Actualiza la mascota con la ruta de la imagen
        Mascota mascota = mascotaOpt.get();
        mascota.setImagenUrl(imagenUrl);
        mascotaRepository.save(mascota);

        return ResponseEntity.ok(mascotaMapper.toGetMascotaDto(mascota));
    }

    // Actualizar parcialmente una mascota (PATCH)
    @PatchMapping("/{id}")
    public ResponseEntity<GetMascotaDto> updateMascota(@PathVariable Long id, @RequestBody CreateMascotaDto dto) {
        return mascotaService.updateMascota(id, dto)
                .map(mascota -> ResponseEntity.ok(mascotaService.getMascotaById(mascota.getId()).orElse(null)))
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // Eliminar una mascota
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMascota(@PathVariable Long id) {
        if (mascotaService.deleteMascota(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
