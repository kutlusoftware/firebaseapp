import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreKullanimi extends StatefulWidget {
  const FirebaseFirestoreKullanimi({super.key});

  @override
  State<FirebaseFirestoreKullanimi> createState() =>
      _FirebaseFirestoreKullanimiState();
}

class _FirebaseFirestoreKullanimiState
    extends State<FirebaseFirestoreKullanimi> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase ile Veri Ekleme"),
        backgroundColor: Colors.indigo.shade300,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //create

                veriEklemeAdd();
              },
              child: Text(
                "Add ile Veri Ekle",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 15),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //create
                veriEklemeSet();
              },
              child: Text(
                "Set ile Veri Ekle",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void veriEklemeAdd() async {
    Map<String, dynamic> _eklencekUser = {};
    _eklencekUser["name"] = "Sinem";
    _eklencekUser["age"] = 40;
    _eklencekUser["isStudent"] = false;
    _eklencekUser["adress"] = {
      "city": "edirne",
      "distict": "selimiye",
      "street": " Yeni",
    };

    _eklencekUser["colors"] = FieldValue.arrayUnion((["kırmızı", "lacivert"]));

    await firestore.collection("users").add(_eklencekUser);
  }

  void veriEklemeSet() async {
    var yeniDocID = firestore.collection("users").doc().id;

    Map<String, dynamic> _eklenecekUser = {};

    _eklenecekUser["userID"] = yeniDocID;
    _eklenecekUser["name"] = "Gülay";
    _eklenecekUser["age"] = 54;
    _eklenecekUser["school"] = "Abant İzzet Baysal";
    _eklenecekUser["adress"] = {
      "city": "Sakarya",
      "disctict": "Geyve",
      "street": "Gül Evler",
    };

    _eklenecekUser["colors"] = FieldValue.arrayUnion((["kırmızı", "lacivert"]));
    _eklenecekUser["createdAt"] = FieldValue.serverTimestamp();

    await firestore
        .doc("users/$yeniDocID")
        .set(_eklenecekUser, SetOptions(merge: true));
  }
}


/*

Firebase firestore noSQL bir yapıdır.
Dönüş değeri mapdir.

Collection ve document kavramları vardır.
Collection tablo anlamına gelir. İçinde documentleri barındırır.
Document dediğimiz veri anlamına gelir. İçinde field yani değişkenleri barındırr.


Firebase firestore docum. içinbize max 1mb alan verir.
Bir doc 12 bin  field tutabilir.
Veri ekleme 2 türlü olur. 

*******.  Set veya Add.  ********
-Add ile eklerken bir Id ye ulaşmazsınız.




  void veriEklemeSet() async {
    // set ile veri eklemek için ID ye ihtiyac vardır.
    //SetOptions(merge: true)); eklemezsen tüm verileri siler.
    await firestore.doc("users/vJd14sxTvRWwyliCAesn").set({
      "okul": "Marmara Üniversity",
    }, SetOptions(merge: true));
  }

   */