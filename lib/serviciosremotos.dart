import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

var baseRemota = FirebaseFirestore.instance;

class DB{
  static Future insertar(Map<String, dynamic> consola) async {
    return await baseRemota.collection("consolas").add(consola);
  }

  static Future<List> mostrarTodos() async {
    List temporal = [];
    var query = await baseRemota.collection("consolas").get();

    query.docs.forEach((element) {
      Map<String, dynamic> data = element.data();
      data.addAll({
        'id': element.id
      });
      temporal.add(data);
    });

    // Ordenar la lista por el campo "año"
    temporal.sort((a, b) => a['año'].compareTo(b['año']));

    return temporal;
  }

  static Future eliminar(String id) async{
    return await baseRemota.collection("consolas").doc(id).delete();
  }

  static Future actualizar(Map<String, dynamic> consola) async{
    String id = consola['id'];
    consola.remove('id');
    return await baseRemota.collection("consolas").doc(id).update(consola);
  }
}