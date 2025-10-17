Proyecto Clínica Veterinaria 🐾

Aplicación móvil de gestión para una clínica veterinaria desarrollada en Flutter y conectada a un backend Java Spring Boot. Permite el registro y consulta de usuarios y mascotas, gestión de perfiles, 
autenticación segura y funcionalidades adaptadas tanto para clientes como para personal de la clínica.

Índice

  - Descripción

  - Tecnologías

  - Instalación y ejecución

  - Configuración

  - Características principales

  - Roadmap

  - Contribuir

  - Licencia

  - Contacto

Descripción

Este proyecto surge para digitalizar y agilizar los procesos habituales en una clínica veterinaria, facilitando el registro de pacientes (mascotas), la administración de perfiles de usuario, 
la gestión de citas y el historial clínico, así como la comunicación entre veterinarios y clientes. La interfaz intuitiva y el enfoque multiplataforma permiten su uso desde cualquier dispositivo Android conectado 
a la misma red local del backend.

Tecnologías

Frontend: Flutter, Dart

Backend: Java, Spring Boot

Base de datos: MySQL

Autenticación: Spring Security

Dependencias principales Flutter: http, shared_preferences, image_picker

Instalación y ejecución

Requisitos previos

  - Flutter SDK instalado (Guía oficial)

  - Android Studio o Visual Studio Code (con plugins de Flutter y Dart)

  - JDK 17+

  - MySQL Server 8+

  - Backend de la clínica desplegado en Spring Boot

Pasos para ejecutar:

# Clonar el repositorio
git clone https://github.com/Bokiron/ProyectoCFGS-Clinica.git

# Ir al directorio del proyecto
cd clinica-veterinaria-app

# Instalar las dependencias de Flutter
flutter pub get

# Ejecutar la aplicación en modo debug
flutter run

# Construir APK de producción
flutter build apk --release

Configuración

Para acceder a los endpoints del backend desde dispositivos móviles en la misma red, la IP del servidor se gestiona de manera global desde el archivo lib/utils/appConfig.dart. Si tu red o IP cambia, modifícala allí para que la aplicación siga funcionando correctamente.

Características principales

  - Registro y autenticación de usuarios (clientes y personal de clínica)

  - Gestión de perfil de usuario y edición de datos

  - Registro de mascotas con foto, raza, tamaño, sexo y fecha de nacimiento

  - Validaciones avanzadas con expresiones regulares (DNI, email, teléfono, fecha)

  - Sincronización directa con backend Spring Boot vía peticiones HTTP

  - Acceso seguro y control de roles mediante Spring Security en el backend

  - Configuración dinámica de la IP de conexión backend

Licencia

Este proyecto está licenciado bajo la MIT License.




