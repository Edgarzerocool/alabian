import 'dart:convert';

import 'package:alabian/productos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class catalogo extends StatefulWidget {
  const catalogo({Key? key}) : super(key: key);

  @override
  State<catalogo> createState() => _catalogoState();
}

class _catalogoState extends State<catalogo> {
  bool finalizoServicio = false;
  var listaProductos;
  List<productos> lista = [];

  @override
  Widget build(BuildContext context) {
    if(!finalizoServicio){
      recuperarListaPeliculas();
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Productos"),
      ),
      body: finalizoServicio ? vistaListaProductos() : loading(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget loading(){
    return const Center(
      child: Text("sin datos"),
    );
  }

  Widget vistaListaProductos(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, index){
                  return Container(
                    decoration: BoxDecoration(color: index%2 == 0 ? Colors.amberAccent : Colors.cyanAccent),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Titulo: ${lista[index].title}'),
                        Text('Precio: ${lista[index].price}'),
                        Image.network(lista[index].image.toString(), height: 50,),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  recuperarListaPeliculas() async {
    listaProductos = await getProductos();
    if(lista != null){
      setState(() {
        finalizoServicio = true;
      });
    }
  }

  getProductos() async {
    var httpsUri = Uri(
      scheme: 'https',
      host: 'fakestoreapi.com',
      path: '/products',);
    final response = await http.get(httpsUri);
    print(response.statusCode);
    if (response != null) {
      if (response.body != null && response.body.isNotEmpty) {
        if (response.statusCode == 200) {
          var respuesta = response.body;
          print (respuesta);
          List nuevaLista = jsonDecode(response.body);
          print(nuevaLista[0]);
          for (var elemento in nuevaLista) {
            lista.add(productos.fromJson(elemento));
            print(elemento);
          }
          return lista;
        }else if (response.statusCode == 401) {
          print("error");
          return null;
        }
        else if (response.statusCode == 429) {
          print("error");
          return null;
        }
      }
    }
    return null;
  }

}
