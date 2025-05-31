package com.example.clinica.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.example.clinica.entities.Producto;
import com.example.clinica.entities.Producto.EspecieProducto;

import java.util.List;

@Repository
public interface ProductoRepository extends JpaRepository<Producto, Long> {
    // filtro para buscar por especias, con containing, JPA busca dentro de listas
    List<Producto> findByEspeciesContaining(EspecieProducto especies);
    List<Producto> findByCategoria(Producto.CategoriaProducto categoria);
    List<Producto> findByEspeciesContainingAndCategoria(Producto.EspecieProducto especie, Producto.CategoriaProducto categoria);
    List<Producto> findByMarca(String marca);
}

