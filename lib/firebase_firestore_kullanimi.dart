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
            SizedBox(height: 25),

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
                //veriEklemeSet();
                //ID li Veri Ekleme
                veriEklemeSet();
              },
              child: Text(
                "Set ile Veri Ekle",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

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
                //veriEklemeSet();
                //ID li Veri Ekleme
                idVeriEklemeSet();
              },
              child: Text(
                "ID ile Veri Ekle- Set",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //Güncelleme
                dataUpdate();
              },
              child: Text(
                "Güncelleme",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),

            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //Güncelleme
                dataDelete();
              },
              child: Text(
                "Sil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),
            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //Güncelleme
                dataFieldDelete();
              },
              child: Text(
                "Field Silme('Okul')",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),

            SizedBox(height: 10),
            Divider(thickness: 1),
            SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //Güncelleme
                dataMapFieldDelete();
              },
              child: Text(
                "Map Silme('Okul')",
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
    _eklencekUser["name"] = "Özge";
    _eklencekUser["age"] = 40;
    _eklencekUser["school"] = "Boğaziçi Üni.";
    _eklencekUser["adress"] = {
      "yetki": "edirne",
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
    _eklenecekUser["name"] = "Özge";
    _eklenecekUser["age"] = 40;
    _eklenecekUser["school"] = "Boğaziçi Üni.";
    _eklenecekUser["adress"] = {"city": "İzmir", "street": "Çiçek"};
    _eklenecekUser["colors"] = FieldValue.arrayUnion((["Yeşil", "Mavi"]));
    _eklenecekUser["createdAt"] = FieldValue.serverTimestamp();
    await firestore
        .doc("users/$yeniDocID")
        .set(_eklenecekUser, SetOptions(merge: true));
  }

  //increment(-3)=> 3'er 3'er eksilecek.
  void idVeriEklemeSet() async {
    await firestore.doc("users/Yl3jVLP5bldMwIPBwZse").set({
      "age": FieldValue.increment(-3),
    }, SetOptions(merge: true));
  }

  void dataUpdate() async {
    await firestore.doc("users/YLwv97lorpgkixiLwE5J").update({
      "name": "Cansu",
      "age": 30,
    });
  }

  void dataDelete() async {
    await firestore.doc("users/Yl3jVLP5bldMwIPBwZse").delete();
  }

  void dataFieldDelete() async {
    await firestore.doc("users/vJd14sxTvRWwyliCAesn").update({
      "okul": FieldValue.delete(),
    });
  }

  void dataMapFieldDelete() async {
    await firestore.doc("users/vJd14sxTvRWwyliCAesn").update({
      "adress.city": FieldValue.delete(),
    });
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


Set de güncelleme yaparken o id yoksa yeni bir Id oluşturur. 
Add de. güncellemede ise hata fırlatır.



   */