import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:login_flutter/models/student.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  Student myStudent = Student(fname: "", lname: "", email: "", score: "");
  
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _studentCollection = FirebaseFirestore.instance.collection("students");
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) { //ถ้าerror
            return Scaffold(
              appBar: AppBar(
                title: Text("error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            //ตรวจการconnect firebase
            return Scaffold(
              appBar: AppBar(
                title: Text("Form"),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ชื่อ", style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนชื่อด้วยครับ"),
                              onSaved: (String? fname) {
                                myStudent.fname = fname!;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("นามสกุล", style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนนามสกุลด้วยครับ"),
                              onSaved: (String? lname) {
                                myStudent.lname = lname!;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("E-mail", style: TextStyle(fontSize: 20)),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: MultiValidator([
                                EmailValidator(
                                    errorText: "รูปแบบอีเมล์ไม่ถูกต้อง"),
                                RequiredValidator(
                                    errorText: "กรุณาป้อนอีเมล์ด้วยครับ"),
                              ]),
                              onSaved: (String? email) {
                                myStudent.email = email!;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("คะแนน", style: TextStyle(fontSize: 20)),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              validator: RequiredValidator(
                                  errorText: "กรุณาป้อนคะแนนด้วยครับ"),
                              onSaved: (String? score) {
                                myStudent.score = score!;
                              },
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: Text("บันทึกข้อมูล",
                                      style: TextStyle(fontSize: 20)),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      await  _studentCollection.add({
                                        "fname":myStudent.fname,
                                        "lname":myStudent.lname,
                                        "email":myStudent.email,
                                        "score":myStudent.score,
                                      });
                                      _formKey.currentState!.reset();
                                    }
                                  }),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("load"),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
