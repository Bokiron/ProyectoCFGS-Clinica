package com.example.clinica.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "lineas_carrito")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LineaCarrito {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "carrito_id")
    private Carrito carrito;

    @ManyToOne
    @JoinColumn(name = "producto_id")
    private Producto producto;

    private int cantidad;

    // Opcional: para marcar si el producto está seleccionado para el pedido
    // (puede gestionarse en el frontend si prefieres)
    private boolean seleccionado = true;
}
