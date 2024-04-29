
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/m_hike.dart';

const String TODO_COLLECTION_REF="mhike_database";

class DatabaseService{
  final _fierstore=FirebaseFirestore.instance;
  late final CollectionReference _todosRef;
  DatabaseService(){
    _todosRef=_fierstore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
        fromFirestore: (snapshots,_)=>Todo.formJson(
          snapshots.data()?.cast<String, Object>(),
        ) ,
        toFirestore: (todo,_)=>todo.toJson());
  }
  Stream<QuerySnapshot> getTodos(){
    return _todosRef.snapshots();
  }
  Stream<QuerySnapshot> getfind(String nameColumn,String searchName){
    return _todosRef.where(nameColumn,isEqualTo: searchName).snapshots();
  }
  Future<void> updateTodo(String todoId, Todo todo) async {
    try {
      await _todosRef.doc(todoId).update(todo.toJson());
      print('Todo updated successfully!'); // Informative success message
    } catch (error) {
      print('Error updating todo: $error'); // Log the error for debugging
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await _todosRef.add(todo);
      print('Todo added successfully!'); // Informative success message
    } catch (error) {
      print('Error adding todo: $error'); // Log the error for debugging
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      await _todosRef.doc(todoId).delete();
      print('Todo deleted successfully!'); // Informative success message
    } catch (error) {
      print('Error deleting todo: $error'); // Log the error for debugging
    }
  }
}