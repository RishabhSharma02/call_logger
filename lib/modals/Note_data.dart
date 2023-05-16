import 'package:flutter/material.dart';

import 'Note.dart';

class Notedata extends ChangeNotifier{
  List<Note> notes=[];
  List<Note> getnotes(){
      return notes;
  }
  void addnew(Note note){
    notes.add(note);
    notifyListeners();
  }
  void updateNote(Note note,String text){
    for(int i=0;i<notes.length;i++){
      if(notes[i].id==note.id){
        notes[i].note=text;
      }
    }
    notifyListeners();
  }
  void deletenote(Note note){
     notes.remove(note);
     notifyListeners();
  }
}