package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.example.clinica.entities.Cita;
import com.example.clinica.entities.Servicio;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface CitaRepository extends JpaRepository<Cita, Long> {
    List<Cita> findByMascotaId(Long mascotaId); // Obtener citas de una mascota
    List<Cita> findByEspacio(String espacio);
    List<Cita> findByServicio(Servicio servicio);
    // Busca citas en el mismo espacio, fecha y hora
    boolean existsByEspacioAndEstadoAndFechaCita(Cita.Espacio espacio, Cita.EstadoCita estado, LocalDateTime fechaCita);
    //Lista de horas ocupadas en una fecha, espacio y que estén confirmadas
    List<Cita> findByEspacioAndEstadoAndFechaCitaBetween(
        Cita.Espacio espacio, Cita.EstadoCita estado, LocalDateTime start, LocalDateTime end
    );

    //Buscar todas las citas de un usuario. Ordenado por fecha, descendiente.
    List<Cita> findByUsuarioDniOrderByFechaCitaAsc(String dni);

    //eliminar citas de una mascota
    @Modifying
    @Query("DELETE FROM Cita c WHERE c.mascota.id = :mascotaId")
    void deleteByMascotaId(@Param("mascotaId") Long mascotaId);

    //buscar citas proximas confirmadas de un ususario
    List<Cita> findByUsuarioDniAndEstadoAndFechaCitaAfterOrderByFechaCitaAsc(String dni, Cita.EstadoCita estado, LocalDateTime fechaCita);
    
    //historial citas del usuario
    @Query("SELECT c FROM Cita c WHERE c.usuario.dni = :dni AND ((c.estado = 'CANCELADA') OR (c.fechaCita < :ahora)) ORDER BY c.fechaCita DESC")
    List<Cita> findHistorialByUsuario(@Param("dni") String dni, @Param("ahora") LocalDateTime ahora);

}
