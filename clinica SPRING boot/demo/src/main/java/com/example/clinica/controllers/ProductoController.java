package com.example.clinica.controllers;

import com.example.clinica.dtos.CreateProductoDto;
import com.example.clinica.dtos.GetProductoDto;
import com.example.clinica.dtos.UpdateProductoDto;
import com.example.clinica.entities.Producto;
import com.example.clinica.services.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/productos")
public class ProductoController {

    @Autowired //Spring crea automáticamente una instancia de ProductoRepository y la asigna al campo correspondiente en ProductoService
    private ProductoService productoService;

    // Obtener todos los productos o filtrar por especie/categoría
    @GetMapping
    public List<GetProductoDto> getProductos(
            @RequestParam(required = false) Producto.EspecieProducto especies,
            @RequestParam(required = false) Producto.CategoriaProducto categoria,
            @RequestParam(required = false) String marca
    ) {
        return productoService.findByEspecieCategoriaMarca(especies, categoria, marca);
    }


    // Obtener producto por ID
    @GetMapping("/{id}")
    public GetProductoDto getProductoById(@PathVariable Long id) {
        return productoService.findById(id);
    }

    // Crear producto (solo admin, pero aquí sin seguridad por simplicidad)
    @PostMapping
    public GetProductoDto createProducto(@RequestBody CreateProductoDto dto) {
        return productoService.create(dto);
    }
    //Crear multiples productos
    @PostMapping("/bulk")
    public List<GetProductoDto> createProductos(@RequestBody List<CreateProductoDto> productos) {
        return productoService.createAll(productos);
    }


    @PatchMapping("/{id}")
    public GetProductoDto updateProducto(@PathVariable Long id, @RequestBody UpdateProductoDto dto) {
        return productoService.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void deleteProducto(@PathVariable Long id) {
        productoService.delete(id);
    }

    @DeleteMapping("/all")
    public void deleteAllProductos() {
        productoService.deleteAll();
    }
}

