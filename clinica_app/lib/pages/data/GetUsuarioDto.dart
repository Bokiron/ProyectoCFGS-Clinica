class GetUsuarioDto {
  final String dni;
  final String nombre;
  final String email;
  final String telefono;
  final String rol;

  GetUsuarioDto({
    required this.dni,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.rol,
  });

  factory GetUsuarioDto.fromJson(Map<String, dynamic> json) {
    return GetUsuarioDto(
      dni: json['dni'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      rol: json['rol'],
    );
  }
}