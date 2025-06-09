package com.example.clinica.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .authorizeHttpRequests(auth -> auth
                // RUTAS PÚBLICAS (acceso sin autenticación)
                // Registro y login
                .requestMatchers(HttpMethod.POST, "/usuarios", "/usuarios/login").permitAll()
                // Mascotas
                .requestMatchers(HttpMethod.POST, "/mascotas", "/mascotas/*/imagen").permitAll()
                .requestMatchers(HttpMethod.GET, "/mascotas/buscar").permitAll()
                // Citas
                .requestMatchers(HttpMethod.POST, "/citas").permitAll()
                .requestMatchers(HttpMethod.GET, "/citas/ocupadas", "/citas/usuario/*", "/citas/usuario/*/proximas", "/citas/usuario/*/historial").permitAll()
                .requestMatchers(HttpMethod.PATCH, "/citas/**", "/mascotas/**").permitAll()
                // Servicios y productos
                .requestMatchers(HttpMethod.GET, "/servicios", "/servicios/**", "/productos").permitAll()
                // Carrito
                .requestMatchers(HttpMethod.GET, "/carrito/**").permitAll()
                .requestMatchers(HttpMethod.POST, "/carrito/**").permitAll()
                .requestMatchers(HttpMethod.PUT, "/carrito/**", "/usuarios/**").permitAll()
                .requestMatchers(HttpMethod.DELETE, "/carrito/**", "/mascotas/**").permitAll()
                // Imágenes
                .requestMatchers("/*.jpg", "/*.png", "/*.jpeg").permitAll()
                // Usuarios (GET ya está permitido arriba, aquí solo para orden)
                .requestMatchers(HttpMethod.GET, "/usuarios/**").permitAll()

                // RUTAS PROTEGIDAS (requieren autenticación y rol ADMIN)

                // Todas las demás rutas requieren autenticación (y solo ADMIN puede autenticarse)
                .anyRequest().authenticated()
            )
            .httpBasic(); // Autenticación básica

        return http.build();
    }

    //usuario que tiene autorización básica, para Postman
    @Bean
    public InMemoryUserDetailsManager userDetailsService() {
        UserDetails user = User.builder()
            .username("root")
            .password(passwordEncoder().encode("1234"))
            .roles("ADMIN")
            .build();
        return new InMemoryUserDetailsManager(user);
    }

    //Configuracion para encriptar contrseñas
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}


