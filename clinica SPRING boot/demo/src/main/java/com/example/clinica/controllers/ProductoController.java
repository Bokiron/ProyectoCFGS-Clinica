package com.example.clinica.controllers;

import com.example.clinica.dtos.CreateProductoDto;
import com.example.clinica.dtos.GetProductoDto;
import com.example.clinica.dtos.UpdateProductoDto;
import com.example.clinica.entities.Producto;
import com.example.clinica.mappers.ProductoMapper;
import com.example.clinica.repositories.ProductoRepository;
import com.example.clinica.services.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/productos")
public class ProductoController {


    @Autowired //Spring crea automáticamente una instancia de ProductoRepository y la asigna al campo correspondiente en ProductoService
    private ProductoService productoService;
    @Autowired //Spring crea automáticamente una instancia de ProductoRepository y la asigna al campo correspondiente en ProductoService
    private ProductoMapper productoMapper;
    @Autowired //Spring crea automáticamente una instancia de ProductoRepository y la asigna al campo correspondiente en ProductoService
    private ProductoRepository productoRepository;

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

    //metodo para subir imagen
    @PostMapping(value = "/{id}/imagen", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<GetProductoDto> subirImagenProducto(
            @PathVariable Long id,
            @RequestParam("imagen") MultipartFile imagen) throws IOException {

        // Busca el producto
        Producto producto = productoRepository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Producto no encontrado"));

        // Guarda la imagen y obtén la ruta
        String imagenUrl = productoService.guardarImagen(id, imagen);

        // Actualiza el producto con la ruta de la imagen
        producto.setImagen(imagenUrl);
        productoRepository.save(producto);

        return ResponseEntity.ok(productoMapper.toGetProductoDto(producto));
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

