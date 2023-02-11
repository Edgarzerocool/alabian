import 'package:alabian/registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'catalogo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Alabian'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool resultadoValidacionEmail = false;
  bool resultadoValidacionPassword = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Captura los datos para ingresar:',
            ),
            Center(
                child:  Padding( padding: const EdgeInsets.all(9.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.alternate_email),
                          hintText: 'Ingrese correo electronico',
                          labelText: 'correo electronico',
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
                          hintText: 'Ingrese su contraseña',
                          labelText: 'Contraseña',
                        ),
                      ),
                      CupertinoButton(
                          child: const Text("Ingresar", style: TextStyle(color: Colors.black),),
                          onPressed: (){
                            if(validacionEmail(email.text) && validacionPassword(password.text)){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const catalogo()),);
                            }else{
                              mostrarAlerta();
                            }
                          }),
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextButton(
                            child: const Text("Registro de nuevo usuario"),
                            onPressed: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const registro()),);
                            },
                        ),
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

  mostrarAlerta (){
    String contenidoError = "";
    if(!resultadoValidacionEmail && !resultadoValidacionPassword){
      contenidoError = "Verifique que los datos esten llenados correctamente, tanto el correo como el password";
    }else if(!resultadoValidacionEmail){
      contenidoError = "Por favor revisar que el correo sea valido";
    }else if(!resultadoValidacionPassword){
      contenidoError = "Por favor ingrese la contraseña";
    }

    showDialog(
      context: context,
      builder: (_) =>  AlertDialog(
        title: Container(
          color: Colors.red,
            child: const Text("Error", textAlign: TextAlign.center)),
        titleTextStyle: const TextStyle(backgroundColor: Colors.red),
        content: Text(contenidoError),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          )
        ],
      ),
    );
  }

  bool validacionEmail (String mail) {
    resultadoValidacionEmail = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
        .hasMatch(mail);
    return resultadoValidacionEmail;
  }

  bool validacionPassword(String password) {
    resultadoValidacionPassword = password.isNotEmpty ? true : false;
    return resultadoValidacionPassword;
  }
}

