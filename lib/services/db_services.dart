import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class DatabaseService {
  CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("Todos");

  Future createNewTodo(String content) async {
    await todoCollection.add({
      "content": content,
      "isCompleted": false,
    });
  }

  Future completedTodo(uid) async {
    await todoCollection.doc(uid).update({"isCompleted": true});
  }

  Future removeTodo(uid) async {
    await todoCollection.doc(uid).delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return Todo(
            isCompleted: e.data()["isCompleted"],
            content: e.data()["content"],
            uid: e.id);
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>> listTodos() {
    return todoCollection.snapshots().map(todoFromFirestore);
  }
}
