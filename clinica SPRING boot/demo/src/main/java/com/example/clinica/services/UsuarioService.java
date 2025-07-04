package com.example.clinica.services;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.security.crypto.password.PasswordEncoder;
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
    private final PasswordEncoder passwordEncoder;

    // Constructor que inyecta el repositorio y el mapper
    public UsuarioService(UsuarioRepository usuarioRepository, UsuarioMapper usuarioMapper, PasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.usuarioMapper = usuarioMapper;
        this.passwordEncoder = passwordEncoder;
    }

    // Obtener todos los usuarios
    public List<GetUsuarioDto> getAllUsuarios() {
        return usuarioRepository.findAll()
                .stream()
                .map(usuarioMapper::toGetUsuarioDto)
                .collect(Collectors.toList());
    }

    // Obtener un usuario por DNI
    public Optional<GetUsuarioDto> getUsuarioByDni(String dni) {
        return usuarioRepository.findByDni(dni).map(usuarioMapper::toGetUsuarioDto);
    }

    // Obtener un usuario por email
    public Optional<GetUsuarioDto> getUsuarioByEmail(String email) {
        return usuarioRepository.findByEmail(email).map(usuarioMapper::toGetUsuarioDto);
    }

    // Obtener un usuario por DNI para login
    public Optional<Usuario> getUsuarioByDniLogin(String dni) {
        return usuarioRepository.findByDni(dni);
    }

    // Para login, verifica la contraseña:
    public boolean login(String dni, String contrasena) {
        return usuarioRepository.findByDni(dni)
            .map(u -> passwordEncoder.matches(contrasena, u.getContrasena()))//spring security compara la contraseña con el hash
            .orElse(false);
    }

    /*//OBtener usuario por email o DNI
    public Optional<Usuario> findByDniOrEmail(String dniOrEmail) {
        // Busca primero por DNI, si no encuentra, busca por email
        Optional<Usuario> usuario = usuarioRepository.findByDni(dniOrEmail);
        if (usuario.isPresent()) {
            return usuario;
        } else {
            return usuarioRepository.findByEmail(dniOrEmail);
        }
    }*/

    // Crear un nuevo usuario
    public Usuario createUsuario(CreateUsuarioDto dto) {
        Usuario nuevoUsuario = usuarioMapper.toUsuario(dto);
        nuevoUsuario.setContrasena(passwordEncoder.encode(dto.getContrasena()));
        return usuarioRepository.save(nuevoUsuario);
    }

    // Actualizar un usuario
    public Optional<Usuario> updateUsuario(String dni, CreateUsuarioDto dto) {
        return usuarioRepository.findByDni(dni).map(usuario -> {
            usuario.setNombre(dto.getNombre());
            usuario.setApellidos(dto.getApellidos());
            usuario.setEmail(dto.getEmail());
            usuario.setTelefono(dto.getTelefono());
            usuario.setContrasena(passwordEncoder.encode(dto.getContrasena()));
            return usuarioRepository.save(usuario);
        });
    }
    //actualizar el rol de los usuarios
    public Optional<Usuario> updateUsuarioRol(String dni, Usuario.Rol nuevoRol) {
    return usuarioRepository.findByDni(dni).map(usuario -> {
        usuario.setRol(nuevoRol);
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
