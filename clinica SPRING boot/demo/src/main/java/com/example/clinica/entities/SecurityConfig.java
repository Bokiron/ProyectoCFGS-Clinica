package com.example.clinica.entities;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
    .csrf().disable()
    .authorizeHttpRequests(auth -> auth
        // Permitir registro y login sin autenticación
        .requestMatchers(HttpMethod.POST, "/usuarios", "/usuarios/login", "/mascotas", "/mascotas/*/imagen", "/citas").permitAll()
        // Permitir acceso a GET /usuarios/{dni} y /mascotas/buscar sin autenticación
        .requestMatchers(HttpMethod.GET, "/usuarios/**", "/mascotas/buscar", "/citas/ocupadas", "/citas/usuario/*").permitAll()
        // Permitir acceso público a los servicios
        .requestMatchers(HttpMethod.GET, "/servicios", "/servicios/**", "/productos").permitAll()
        //Permitir actualizar citas
        .requestMatchers(HttpMethod.PATCH, "/citas/**").permitAll()

        // Permitir que se acceda a las imágenes
        .requestMatchers("/*.jpg", "/*.png", "/*.jpeg").permitAll()
        // Todas las demás rutas requieren autenticación
        .anyRequest().authenticated()
    )
    .httpBasic();// Opcional: si usas autenticación básica

        return http.build();
    }
}


