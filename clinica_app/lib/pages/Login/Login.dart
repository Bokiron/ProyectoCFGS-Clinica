import 'dart:convert';
import 'package:clinica_app/pages/Login/ChangePassword.dart';
import 'package:clinica_app/pages/Inicio.dart';
import 'package:clinica_app/pages/Login/SignUp.dart';
import 'package:clinica_app/pages/utils/appConfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool rememberMe = false; // Estado del checkbox para recordar sesión
  bool _obscureText = true; // Visibilidad de la contraseña
  final usuarioController = TextEditingController();
  final contrasenaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent, // Para que el fondo siga siendo la imagen
    body: Stack(
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
                        labelText: "DNI",
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
    ),
  );
  }

  //Este metodo hace que si el login es correcto guarde, guardemos el dni y rol del usuario en sharedPrefences,
  //obteniendolos a través de una consulta GET a la BBDD
  Future<void> loginUsuario() async {
    //funcion de login
    final url = Uri.parse('${AppConfig.baseUrl}/usuarios/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "dni": usuarioController.text,
        "contrasena": contrasenaController.text,
      }),
    );
  //si login es exitoso
    if (response.statusCode == 200) {
      // Login correcto: ahora obtenemos la info del usuario desde la bbdd
      //(podria bastar con guardar el dni desde el textfield pero como tambien hace falta el rol, cogemos los dos desde laBBDD y ya esta)
      final dni = usuarioController.text.trim();
      final infoUrl = Uri.parse('${AppConfig.baseUrl}/usuarios/$dni');
      final infoResponse = await http.get(infoUrl);

      if (infoResponse.statusCode == 200) {
        final data = jsonDecode(infoResponse.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('dni_usuario', data['dni']);//guarda dni
        await prefs.setString('rol_usuario', data['rol']); // Guarda el rol

        // Ahora puedes navegar según el rol si quieres:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Inicio()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo obtener la información del usuario')),
        );
      }
    } else {
      // Login incorrecto
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}')),
      );
    }
  }
}
