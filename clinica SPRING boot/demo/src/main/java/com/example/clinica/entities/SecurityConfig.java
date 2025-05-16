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
                .requestMatchers(HttpMethod.POST, "/usuarios", "/usuarios/login", "/mascotas", "/mascotas/*/imagen").permitAll()
                // Permitir acceso a GET /usuarios/{dni} sin autenticación
                .requestMatchers(HttpMethod.GET, "/usuarios/**", "/mascotas/buscar").permitAll()
                //permitir que se acceda a las imagenes
                .requestMatchers("/*.jpg", "/*.png", "/*.jpeg").permitAll()
                // Todas las demás rutas requieren autenticación
                .anyRequest().authenticated()
            )
            .httpBasic(); // Opcional: si usas autenticación básica

        return http.build();
    }
}


