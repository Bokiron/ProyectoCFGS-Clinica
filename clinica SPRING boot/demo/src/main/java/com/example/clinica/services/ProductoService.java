package com.example.clinica.services;

import com.example.clinica.dtos.CreateProductoDto;
import com.example.clinica.dtos.GetProductoDto;
import com.example.clinica.dtos.UpdateProductoDto;
import com.example.clinica.entities.Producto;
import com.example.clinica.exceptions.ProductoNotFoundException;
import com.example.clinica.mappers.ProductoMapper;
import com.example.clinica.repositories.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductoService {

    @Autowired// Spring crea automáticamente una instancia de ProductoRepository y la asigna al campo correspondiente en ProductoService
    private ProductoRepository productoRepository;

    @Autowired
    private ProductoMapper productoMapper;

    // Obtener todos los productos
    public List<GetProductoDto> findAll() {
        return productoRepository.findAll()
                .stream()
                .map(productoMapper::toGetProductoDto)
                .collect(Collectors.toList());
    }

    // Obtener producto por ID
    public GetProductoDto findById(Long id) {
        Producto producto = productoRepository.findById(id)
                .orElseThrow(() -> new ProductoNotFoundException(id));
        return productoMapper.toGetProductoDto(producto);
    }

    // Crear producto
    public GetProductoDto create(CreateProductoDto dto) {
        Producto producto = productoMapper.toProducto(dto);
        Producto saved = productoRepository.save(producto);
        return productoMapper.toGetProductoDto(saved);
    }
    
    //Crear multiples productos
    public List<GetProductoDto> createAll(List<CreateProductoDto> dtos) {
        List<Producto> productos = dtos.stream()
            .map(productoMapper::toProducto)
            .collect(Collectors.toList());
        List<Producto> saved = productoRepository.saveAll(productos);
        return saved.stream()
            .map(productoMapper::toGetProductoDto)
            .collect(Collectors.toList());
    }

    // Filtro por especie y/o categoría
    public List<GetProductoDto> findByEspecieCategoriaMarca(
        Producto.EspecieProducto especie,
        Producto.CategoriaProducto categoria,
        String marca
    ) {
        List<Producto> productos;

        // Caso 1: Solo especie
        if (especie != null && categoria == null && marca == null) {
            productos = productoRepository.findByEspeciesContaining(especie);
        }
        // Caso 2: Solo categoría
        else if (categoria != null && especie == null && marca == null) {
            productos = productoRepository.findByCategoria(categoria);
        }
        // Caso 3: Solo marca
        else if (marca != null && especie == null && categoria == null) {
            productos = productoRepository.findByMarca(marca);
        }
        // Caso 4: Especie y categoría
        else if (especie != null && categoria != null && marca == null) {
            productos = productoRepository.findByEspeciesContainingAndCategoria(especie, categoria);
        }
        // Caso 5: Especie y marca
        else if (especie != null && marca != null && categoria == null) {
            productos = productoRepository.findByEspeciesContaining(especie)
                .stream()
                .filter(p -> p.getMarca().equalsIgnoreCase(marca))
                .collect(Collectors.toList());
        }
        // Caso 6: Categoría y marca
        else if (categoria != null && marca != null && especie == null) {
            productos = productoRepository.findByCategoria(categoria)
                .stream()
                .filter(p -> p.getMarca().equalsIgnoreCase(marca))
                .collect(Collectors.toList());
        }
        // Caso 7: Especie, categoría y marca
        else if (especie != null && categoria != null && marca != null) {
            productos = productoRepository.findByEspeciesContainingAndCategoria(especie, categoria)
                .stream()
                .filter(p -> p.getMarca().equalsIgnoreCase(marca))
                .collect(Collectors.toList());
        }
        // Caso 8: Sin filtros
        else {
            productos = productoRepository.findAll();
        }

        return productos.stream()
            .map(productoMapper::toGetProductoDto)
            .collect(Collectors.toList());
    }



    public GetProductoDto update(Long id, UpdateProductoDto dto) {
        Producto producto = productoRepository.findById(id)
                .orElseThrow(() -> new ProductoNotFoundException(id));
        // Solo actualiza los campos que llegan (no null)
        if (dto.getNombre() != null) producto.setNombre(dto.getNombre());
        if (dto.getMarca() != null) producto.setMarca(dto.getMarca());
        if (dto.getCategoria() != null) producto.setCategoria(dto.getCategoria());
        if (dto.getEspecies() != null) producto.setEspecies(dto.getEspecies());
        if (dto.getDescripcion() != null) producto.setDescripcion(dto.getDescripcion());
        if (dto.getImagen() != null) producto.setImagen(dto.getImagen());
        if (dto.getPrecio() != null) producto.setPrecio(dto.getPrecio());

        Producto updated = productoRepository.save(producto);
        return productoMapper.toGetProductoDto(updated);
    }

    public void delete(Long id) {
        if (!productoRepository.existsById(id)) {
            throw new ProductoNotFoundException(id);
        }
        productoRepository.deleteById(id);
    }

    public void deleteAll() {
        productoRepository.deleteAll();
    }
}
