import 'dart:convert';

import 'package:clinica_app/pages/ChangePassword.dart';
import 'package:clinica_app/pages/Inicio.dart';
import 'package:clinica_app/pages/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false; // Estado del checkbox para recordar sesión
  bool _obscureText = true; // Added to manage password visibility
  final usuarioController = TextEditingController();
  final contrasenaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.network(
            'https://consultaveterinarialatorre.com/imagenes/89/empresas/Img-481221-2_amp.jpg',
            fit: BoxFit.cover,
          ),
        ),

        // Capa semitransparente para mejorar la legibilidad
        Positioned.fill(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,//ancho container transparencia
                height: MediaQuery.of(context).size.height * 0.90,//alto container transparencia
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),//opacidad
                  borderRadius: BorderRadius.circular(10),//bordes redondeados
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("lib/assets/logoClinica.png", width: 200, height: 100),

                    const SizedBox(height: 50),//espacio entre escudo y campo DNI

                    // Campo DNI/NIE o Email
                    TextFormField(
                      controller: usuarioController,
                      decoration: const InputDecoration(
                        labelText: "DNI/N.I.F o E-Mail",
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.lightBlueAccent),//cambiar el color del labeltext, cuando esta flotando
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress, // Asegúrate de usar el tipo correcto
                      textInputAction:
                          TextInputAction.next, // Permite pasar al siguiente campo
                    ),

                    const SizedBox(height: 20),//espacio entre dni y contraseña

                    // Campo Contraseña
                    TextFormField(
                      controller: contrasenaController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.lightBlueAccent),//cambiar el color del labeltext, cuando esta flotando
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                              icon: Icon(
                                // Cambiar icono ojo abierto y cerrado
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: _obscureText ? Colors.white: Colors.lightBlueAccent, // Establece color azul si _obscureText es falso
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText; // cambiar visibilidad
                                });
                              },
                            ),
                          ),
                      style:const TextStyle(color:Colors.white),
                    ),
                    
                    const SizedBox(height:20),

                    // Checkbox "Recuérdame" y enlace de ayuda
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children:[
                        Row(
                          children:[
                            Checkbox(value:
                              rememberMe,
                              onChanged:
                              (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              }),
                              const Text("Recuérdame",style:TextStyle(color:Colors.white)),
                          ]
                        ),
                          GestureDetector(
                              onTap: () {
                                // Mostrar diálogo de recuperación de contraseña
                                PasswordResetDialog.show(
                                  context: context,
                                  onSendPressed: (email) {
                                    // Aquí se implemetará la lógica para enviar el correo
                                    print('Enviando email de recuperación a: $email');//Console Log
                                    // llamar a servicio de Firebase Auth, API, etc.
                                  },
                                );
                              },
                            child:
                              const Text(
                                "¿Necesitas ayuda?", style: TextStyle(decoration:TextDecoration.underline, color:Colors.blue),
                              ),
                          ),
                      ]
                    ),

                      Spacer(),//empuja los botones al fondo de la transparencia

                      // Botón Entrar
                      ElevatedButton(
                        onPressed: () {
                          // Acción de inicio de sesión
                          loginUsuario();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          minimumSize: const Size(double.infinity, 50), // Define tamaño mínimo directamente
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                        ),
                        child: const Text(
                          "ENTRAR",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 15), // Espaciado entre botones

                      // Botón Inscribirse
                      ElevatedButton(
                        onPressed: () {
                          // Acción para inscribirse
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50), // Define tamaño mínimo directamente
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          ),
                        ),
                        child: const Text(
                          "REGISTRARME",
                          style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> loginUsuario() async {
  final url = Uri.parse('http://10.0.2.2:8080/usuarios/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "dniOrEmail": usuarioController.text,
      "contrasena": contrasenaController.text,
    }),
  );

  if (response.statusCode == 200) {
    // Login correcto
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Inicio()),
    );
  } else {
    // Login incorrecto
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}'))  
    );
  }
}
}
