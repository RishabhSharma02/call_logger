import 'package:call_logger_project/modals/Note.dart';
import 'package:call_logger_project/modals/Note_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class Notes_screen extends StatefulWidget {
  const Notes_screen({super.key});

  @override
  State<Notes_screen> createState() => _Notes_screenState();
}

class _Notes_screenState extends State<Notes_screen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Notedata>(
      builder: (context, value, child) => Container(
          color: Color.fromARGB(255, 255, 255, 255),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView(
                            children: snapshot.data!.docs
                                .map((note) => Card(
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    left: 30,
                                                    top: 5,
                                                    bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  note["phone_no"]
                                                      .toString()
                                                      .substring(0, 10),
                                                  style:
                                                      GoogleFonts.nunito(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets
                                                              .only(
                                                          top: 8.0,
                                                          left: 20),
                                                  child: GestureDetector(
                                                    onTap: () async{
                                                                              final collection = FirebaseFirestore
                                      .instance
                                      .collection('notes');

                                  collection.doc(note.id).delete();
                                                    },
                                                      child: Icon(
                                                          PhosphorIcons
                                                              .regular
                                                              .trash)),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    left: 30,
                                                    top: 5,
                                                    bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  note["date_created"],
                                                  style:
                                                      GoogleFonts.nunito(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    left: 30,
                                                    top: 5,
                                                    bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Reason : " +
                                                            note[
                                                                "reason"],
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    left: 30,
                                                    top: 5,
                                                    bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Note : " +
                                                            note["notes"],
                                                        style: GoogleFonts.nunito(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                                .toList()));
                  }
                  return Text("There's no data");
                },
              )
            ],
          )),
    );
  }
}
