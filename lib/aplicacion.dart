import 'dart:io';

import 'package:dam_add_firestore/serviciosremotos.dart';
import 'package:flutter/material.dart';

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  String titulo = "Colección de Consolas";
  int _index = 0;
  String idtemp = "";
  String nomtemp = "";
  String martemp = "";
  String imgtemp = "";
  int gentemp = 0;
  int anotemp = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(titulo),
      ),
      body: dinamico(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(child: Text("AJ"),),
                SizedBox(height: 20,),
                Text("Ángel Jauregui", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
              decoration: BoxDecoration(color: Colors.black54),
            ),
            _item(Icons.add, "Insertar", 1),
            _item(Icons.format_list_bulleted, "Lista", 0),
            _item(Icons.exit_to_app, "Salir", 3),
          ],
        ),
      ),

    );
  }

  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto),flex: 2,)],
      ),
    );
  }

  Widget dinamico(){
    if(_index==1){
      return capturar();
    }
    if(_index==2){
      setState(() {
        titulo = "Editar Consola";
      });
      return actualizar();
    }
    if(_index==3){
      exit(0);
    }
    return cargarData();
  }

  Widget cargarData(){
    return FutureBuilder(
        future: DB.mostrarTodos(),
        builder: (cxt, listaJSON){
          if (listaJSON.hasData){
            return ListView.builder(
              itemCount: listaJSON.data?.length,
              itemBuilder: (ct, id){
                return ListTile(
                  leading: SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.network(listaJSON.data?[id]['img'])
                  ),
                  title: Text("${listaJSON.data?[id]['nombre']}"),
                  subtitle: Text("Marca: ${listaJSON.data?[id]['marca']}\n"
                      "Generación: ${listaJSON.data?[id]['generacion']}°\n"
                      "Año: ${listaJSON.data?[id]['año']}"),
                  trailing: IconButton(
                    onPressed: () {
                      // Mostrar cuadro de diálogo de confirmación
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmar eliminación'),
                            content: Text('¿Estás seguro de que deseas eliminar esta consola?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Eliminar el registro
                                  DB.eliminar(listaJSON.data?[id]['id'])
                                      .then((value) {
                                    setState(() {
                                      titulo = "Registro eliminado!";
                                    });
                                    Future.delayed(Duration(seconds: 2), () {
                                      setState(() {
                                        titulo = "Colección de Consolas";
                                      });
                                    });
                                  });
                                  Navigator.pop(context); // Cerrar el cuadro de diálogo
                                },
                                child: Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: (){
                    idtemp  = listaJSON.data?[id]['id'];
                    nomtemp = listaJSON.data?[id]['nombre'];
                    martemp = listaJSON.data?[id]['marca'];
                    gentemp = listaJSON.data?[id]['generacion'];
                    anotemp = listaJSON.data?[id]['año'];
                    imgtemp = listaJSON.data?[id]['img'];
                    setState(() {
                      _index = 2;
                    });
                  },
                );
              }
            );
          }
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }


  Widget actualizar(){
    final nombre = TextEditingController();
    final marca = TextEditingController();
    final generacion = TextEditingController();
    final ano = TextEditingController();
    final img = TextEditingController();

    nombre.text = nomtemp;
    marca.text = martemp;
    generacion.text = gentemp.toString();
    ano.text = anotemp.toString();
    img.text = imgtemp;
    setState(() {
      titulo = "Actualizar Consola";
    });
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: marca,
          decoration: InputDecoration(
              labelText: "Marca:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: generacion,
          decoration: InputDecoration(
              labelText: "Generación:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: ano,
          decoration: InputDecoration(
              labelText: "Año:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: img,
          decoration: InputDecoration(
              labelText: "Url de la imagen:"
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JsonTemporal = {
                    'id': idtemp,
                    'nombre': nombre.text,
                    'marca': marca.text,
                    'generacion': int.parse(generacion.text),
                    'año': int.parse(ano.text),
                    'img': img.text
                  };
                  DB.actualizar(JsonTemporal)
                      .then((value){
                    setState(() {
                      titulo = "Actualización exitosa!";
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        titulo = "Colección de Consolas";
                        _index = 0;
                      });
                    });
                  });
                },
                child: Text("Actualizar")
            ),
            ElevatedButton(
                onPressed: (){
                  titulo = "Colección de Consolas";
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }

  Widget capturar(){
    final nombre = TextEditingController();
    final marca = TextEditingController();
    final generacion = TextEditingController();
    final ano = TextEditingController();
    final img = TextEditingController();


    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: marca,
          decoration: InputDecoration(
              labelText: "Marca:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: generacion,
          decoration: InputDecoration(
              labelText: "Generación:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: ano,
          decoration: InputDecoration(
              labelText: "Año:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        TextField(
          controller: img,
          decoration: InputDecoration(
              labelText: "Url de la imagen:"
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var JsonTemporal = {
                    'nombre': nombre.text,
                    'marca': marca.text,
                    'generacion': int.parse(generacion.text),
                    'año': int.parse(ano.text),
                    'img': img.text
                  };
                  DB.insertar(JsonTemporal)
                      .then((value){
                    setState(() {
                      titulo = "Adición exitosa!";
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        titulo = "Colección de Consolas";
                        _index = 0;
                      });
                    });
                  });
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  titulo = "Colección de Consolas";
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }

}
