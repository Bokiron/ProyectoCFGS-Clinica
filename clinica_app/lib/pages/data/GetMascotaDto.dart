class GetMascotaDto {
  final int id;
  final String nombre;
  final String especie;
  final String raza;
  final String fechaNacimiento;
  final String sexo;
  final String tamano;
  final double peso;
  final String usuarioDni;
  final String? imagenUrl;

  GetMascotaDto({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.fechaNacimiento,
    required this.sexo,
    required this.tamano,
    required this.peso,
    required this.usuarioDni,
    this.imagenUrl
  });

  factory GetMascotaDto.fromJson(Map<String, dynamic> json) {
    return GetMascotaDto(
      id: json['id'],
      nombre: json['nombre'],
      especie: json['especie'],
      raza: json['raza'],
      fechaNacimiento: json['fechaNacimiento'],
      sexo: json['sexo'],
      tamano: json['tamano'],
      peso: (json['peso'] as num).toDouble(),
      usuarioDni: json['usuarioDni'],
      imagenUrl: json['imagenUrl'],
      
    );
  }
}
