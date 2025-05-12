package com.example.clinica.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.example.clinica.dtos.CreateUsuarioDto;
import com.example.clinica.dtos.GetUsuarioDto;
import com.example.clinica.entities.Usuario;
import com.example.clinica.mappers.UsuarioMapper;
import com.example.clinica.repositories.UsuarioRepository;

@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final UsuarioMapper usuarioMapper;

    // Constructor que inyecta el repositorio y el mapper
    public UsuarioService(UsuarioRepository usuarioRepository, UsuarioMapper usuarioMapper) {
        this.usuarioRepository = usuarioRepository;
        this.usuarioMapper = usuarioMapper;
    }

    // Obtener todos los usuarios
    public List<GetUsuarioDto> getAllUsuarios() {
        return usuarioRepository.findAll()
                .stream()
                .map(usuarioMapper::toGetUsuarioDto)
                .collect(Collectors.toList());
    }

    // Obtener un usuario por ID
    public Optional<GetUsuarioDto> getUsuarioByDni(String dni) {
        return usuarioRepository.findByDni(dni).map(usuarioMapper::toGetUsuarioDto);
    }

    // Crear un nuevo usuario
    public Usuario createUsuario(CreateUsuarioDto dto) {
        Usuario nuevoUsuario = usuarioMapper.toUsuario(dto);
        return usuarioRepository.save(nuevoUsuario);
    }

    // Actualizar un usuario
    public Optional<Usuario> updateUsuario(String dni, CreateUsuarioDto dto) {
        return usuarioRepository.findByDni(dni).map(usuario -> {
            usuario.setNombre(dto.getNombre());
            usuario.setEmail(dto.getEmail());
            usuario.setTelefono(dto.getTelefono());
            return usuarioRepository.save(usuario);
        });
    }

    // Eliminar un usuario
    public boolean deleteUsuario(String dni) {
        if (usuarioRepository.existsById(dni)) {
            usuarioRepository.deleteById(dni);
            return true;
        }
        return false;
    }
}
