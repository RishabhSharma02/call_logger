import 'package:call_log/call_log.dart';
import 'package:call_logger_project/modals/Note.dart';
import 'package:call_logger_project/modals/Note_data.dart';
import 'package:call_logger_project/views/Notes_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class Call_log extends StatefulWidget {
  const Call_log({super.key});

  @override
  State<Call_log> createState() => _Call_logState();
}

class _Call_logState extends State<Call_log> {
  int index1 = 0;
  static Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  @override
  Widget build(BuildContext context) {
    final List<String> names = <String>[];
    final List<String> numbs = <String>[];
    final List<String> callType = <String>[];
    final List<String> duration = <String>[];
    for (CallLogEntry entry in _callLogEntries) {
      names.add("${entry.name}");
      numbs.add("${entry.number}");
      callType.add("${entry.callType}");
      duration.add("${entry.duration}");
    }
    final screens = [
      Column(
        children: <Widget>[
          names.isEmpty
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Lottie.network(
                           "https://assets10.lottiefiles.com/packages/lf20_aKRZfw.json"),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height/15),
                      child: Center(
                        child: Text(
                          "All your logs in one place",
                          style: GoogleFonts.nunito(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () async{
                             final Iterable<CallLogEntry> result = await CallLog.query();
                             setState(() {
                               _callLogEntries = result;
                             });
                          },
                          child: Text(
                            "Get logs",
                            style: GoogleFonts.nunito(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                )
              : Expanded(
                  child: ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        names[index] == ""
                            ? "Unknown Number" + "\n" + tomins(duration[index])
                            : names[index] + "\n" + tomins(duration[index]),
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        numbs[index],
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      leading: CircleAvatar(
                          child: Text(
                        names[index] == "" ? "U" : names[index][0],
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      )),
                      trailing: PhosphorIcon(
                          callType[index] == "CallType.missed"
                              ? PhosphorIcons.fill.phoneX
                              : callType[index] == "CallType.outgoing"
                                  ? PhosphorIcons.fill.phoneOutgoing
                                  : PhosphorIcons.fill.phoneIncoming,
                          color: callType[index] == "CallType.missed"
                              ? Colors.amber
                              : callType[index] == "CallType.outgoing"
                                  ? Colors.green
                                  : Colors.red),
                      onTap: () {
                        _dialogBuilder(context,
                            names[index] == "" ? "Unknown" : names[index]);
                      },
                    );
                  }),
                ),
        ],
      ),
      Notes_screen()
    ];

    return Consumer<Notedata>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: NavigationBar(
          height: 75,
          destinations: [
            NavigationDestination(
                icon: PhosphorIcon(PhosphorIcons.regular.house), label: "Home"),
            NavigationDestination(
                icon: PhosphorIcon(PhosphorIcons.regular.note), label: "Notes")
          ],
          selectedIndex: index1,
          onDestinationSelected: (index1) => setState(() {
            this.index1 = index1;
          }),
        ),
        appBar: AppBar(
          title: Text(
            'Call Logger',
            style:
                GoogleFonts.nunito(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          // actions: [
          //   GestureDetector(
          //       onTap: () async {
          //         final Iterable<CallLogEntry> result = await CallLog.query();
          //         setState(() {
          //           _callLogEntries = result;
          //         });
          //       },
          //       child: Icon(Icons.list))
          // ],
        ),
        body: screens[index1],
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context, String number) {
  TextEditingController reason_c = TextEditingController();
  TextEditingController notes_c = TextEditingController();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Consumer<Notedata>(
        builder: (context, value, child) => AlertDialog(
          title: Text('Options for ' + number),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.415,
            width: MediaQuery.of(context).size.width,
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 100, bottom: 15),
                      child: Text(
                        "Add Reason",
                        style: GoogleFonts.nunito(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextField(
                        controller: reason_c,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius: BorderRadius.circular(10)))),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 100, bottom: 15, top: 20),
                      child: Text(
                        "Add Notes",
                        style: GoogleFonts.nunito(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextFormField(
                      controller: notes_c,
                      maxLines: 5,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.circular(10))),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create Note'),
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection("notes")
                    .add({"date_created":DateTime.now().toString().substring(0,10)+" at "+DateTime.now().toString().substring(11,16),
                      "notes": notes_c.text,
                      "reason": reason_c.text,
                      "phone_no": number,
                      "id":FirebaseFirestore.instance
                    .collection("notes").doc().id.toString()
                    })
                    .then((value) =>
                        {print(value.id), Navigator.of(context).pop()})
                    .catchError((error) {
                      print("Failed $error");
                    });
                Fluttertoast.showToast(
                    msg: "Note saved",
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    fontSize: 16.0);
              },
            ),
          ],
        ),
      );
    },
  );
}

String tomins(String s) {
  int time = int.parse(s);
  int sec = time % 60;
  int min = (time / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}
