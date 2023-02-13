import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class registro extends StatelessWidget {
  registro({Key? key}) : super(key: key);
  bool resultadoValidacionEmail = false;
  bool finalizoServicio = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController nombre = TextEditingController();
    TextEditingController apellido = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController telefono = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController validacionPassword = TextEditingController();
    TextEditingController usuario = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de nuevo usuario")),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Por favor llene todo los datos para poder realizar el registro:',
              ),
            ),
            Center(
                child:  Padding( padding: const EdgeInsets.only(top: 9.0, left: 9.0, right: 9.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: nombre,
                                keyboardType: TextInputType.name,
                                decoration:  const InputDecoration(
                                  hintText: 'Nombres(s)',
                                  label: Text('Nombre(s)'),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: apellido,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  hintText: 'Apellidos',
                                  label: Text('Apellidos'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  const InputDecoration(
                          label: Text('correo electronico'),
                          hintText: 'Ingrese correo electronico',
                        ),
                      ),
                      TextFormField(
                        controller: telefono,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          hintText: 'telefono',
                          label: Text('telefono'),
                        ),
                      ),
                      TextFormField(
                        controller: usuario,
                        decoration: const InputDecoration(
                          hintText: 'nombre usuario',
                          label: Text('nombre usuario'),
                        ),
                      ),
                      TextFormField(
                        controller: password,
                        maxLength: 18,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password_outlined),
                          hintText: 'ingrese su contraseña',
                          label: Text('contraseña'),
                        ),
                      ),
                      TextFormField(
                        controller: validacionPassword,
                        maxLength: 18,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password_outlined),
                          hintText: 'valide su contraseña',
                          label: Text('contraseña'),
                        ),
                      ),
                      CupertinoButton(
                        color: Colors.indigo,
                          onPressed:() async {
                            if(validacionEmail(email.text) && (password.text == validacionPassword.text) && telefono.text.length == 10 && nombre.text.isNotEmpty && apellido.text.isNotEmpty && usuario.text.isNotEmpty){
                              if(finalizoServicio == false){
                                String respuesta = await getRegistrarUsuario(email.text, password.text, telefono.text, nombre.text, apellido.text, usuario.text);
                                if(respuesta != ""){
                                  mostrarAlerta(context, respuesta);
                                }
                              }
                            }else{
                              mostrarAlerta(context, 'error');
                            }
                          },
                          child: const Text("REGISTRAR", style: TextStyle(color: Colors.white),)
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  bool validacionEmail (String mail) {
    resultadoValidacionEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
        .hasMatch(mail);
    return resultadoValidacionEmail;
  }

  Future<String> getRegistrarUsuario(String email, String password, String telefono, String nombre, String apellido, String usuario) async {
    var json = {
      'email': email,
      'username': usuario,
      'password': password,
      'name': {
        'firstname': nombre,
        'lastname': apellido
      },
      'phone': telefono
    };
    var body = jsonEncode(json);
    var httpsUri = Uri(
        scheme: 'https',
        host: 'fakestoreapi.com',
        path: '/users',);
    final response = await http.post(httpsUri, body: body);
    print(response.statusCode);
    if (response != null) {
      if (response.body != null && response.body.isNotEmpty) {
        if (response.statusCode == 200) {
          var respuesta = response.body;
          print (respuesta);
          return jsonDecode(respuesta)['id'].toString();
        }else if (response.statusCode == 401) {
          print("error");
          return "";
        }
        else if (response.statusCode == 429) {
          print("error");
          return "";
        }
      }
    }
    return "";
  }

  mostrarAlerta (BuildContext context, String tipoAlerta){
    String contenido = tipoAlerta == 'error' ? "Por favor ingrese los datos solicitados" : 'Este es tu ID: $tipoAlerta';
    String titulo = tipoAlerta == 'error' ? 'Error' : 'Usuario registrado';

    showDialog(
      context: context,
      builder: (_) =>  AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          height: 30,
            color: tipoAlerta == 'error' ? Colors.red : Colors.teal,
            child: Center(child: Text(titulo, textAlign: TextAlign.center))),
        content: Text(contenido),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.indigo)),
            onPressed: () {
              if(tipoAlerta == 'error'){
                Navigator.pop(context);
              }else{
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }
}
