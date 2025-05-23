package com.example.clinica.entities;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.util.List;

@Entity
@Table(name = "productos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Producto {

    public enum CategoriaProducto {
        ALIMENTACION,
        ANTIINFLAMATORIO,
        ARENAS,
        ANTIPARASITARIO,
        COMPLEMENTO_NUTRICIONAL,
        DERMATOLOGIA,
        HIGIENE,
        JUGUETES
    }

    public enum EspecieProducto {
        PERRO,
        GATO,
        LOROS,
        CONEJO
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;

    private String marca;

    @Enumerated(EnumType.STRING)
    private CategoriaProducto categoria;


    @ElementCollection(targetClass = EspecieProducto.class)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "producto_especies", joinColumns = @JoinColumn(name = "producto_id"))
    @Column(name = "especie")
    private List<EspecieProducto> especies;


    @Column(length = 1000)
    private String descripcion;

    // Guarda solo el nombre del archivo o la ruta relativa (ej: "imagenesProductos/123.jpg")
    private String imagen;

    //Utilizamos BigDecimal porque nos ofrece mas precisión que Double
    @Column(precision = 10, scale = 2)
    private BigDecimal precio;

}

