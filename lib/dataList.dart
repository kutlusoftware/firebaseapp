import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataList extends StatefulWidget {
  const DataList({super.key});

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  late FirebaseFirestore firestore;
  late StreamSubscription userSubscribe;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase ile Veri List."),
        backgroundColor: Colors.indigo.shade300,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                dataCountList();
              },
              child: Text(
                "Verilerin Sayısını Listele",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

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
                dataIDList();
              },
              child: Text(
                "Verilerin Sayısını Listele",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.cyan.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                dataRealTime();
              },
              child: Text(
                "Real Time Listele",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                dataStopRealTime();
              },
              child: Text(
                "Real Time Listele",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                changesAllDoc();
              },
              child: Text(
                "Changes All",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                queryingData();
              },
              child: Text(
                "Linq Tipi Sorgular",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  void dataCountList() async {
    var usersDocuments = await firestore.collection("users").get();
    //1. Yol
    debugPrint(usersDocuments.size.toString());
    //2.Yol
    debugPrint(usersDocuments.docs.length.toString());

    //ID'leri Listeleme
    for (var user in usersDocuments.docs) {
      debugPrint("Döküman ID : ${user.id}");
    }
  }

  void dataIDList() async {
    var gulayDoc = await firestore.doc("users/31Gj2IjeM3RNwAlaDSny").get();

    //hepsi yazar
    debugPrint(gulayDoc.data().toString());
    debugPrint(gulayDoc.data()!["age"].toString());
    debugPrint(gulayDoc.data()!["adress"]["street"].toString());
  }

  void dataRealTime() async {
    //stream yapısını kulak gibi düşünebiliriz. Burada bir olay olmuş bana haber ver koleksiyonu ya da dökümanı dinleyebilirsin.
    //Stream döndürür dinleme  için ön hazırlık
    var userStream = firestore.collection("users").snapshots();
    //Dinleme yapıyoruz.
    userSubscribe = userStream.listen((event) {
      //sadece bana değişeni ver aslında tek eleman verir ama foreach ile kullanılır.
      event.docChanges.forEach((user) {
        //Değişiklik olanın bilgisini verir
        debugPrint(user.doc.data().toString());
      });
    });
  }

  void dataStopRealTime() async {
    await userSubscribe.cancel();
  }

  void changesAllDoc() async {
    var userStream = firestore.collection("users").snapshots();
    //Dinleme yapıyoruz.
    userSubscribe = userStream.listen((event) {
      event.docs.forEach((user) {
        debugPrint(user.data().toString());
      });
    });
  }

  void queryingData() async {
    var userRef = firestore.collection("users");
    //38 yaşında olanları listeler.

    var result = await userRef.where("age", isEqualTo: 22).get();

    var result1 = await userRef.where("name", isEqualTo: "Onurr").get();

    for (var user in result.docs) {
      // debugPrint(user.data().toString());
      debugPrint(user.data()["name"]["school"].toString());
    }
  }

  // Yaş Aralığı Yaparak Sorgulama
  void queryingDataTwo() async {
    var userRef = firestore.collection("users");
    var result = await userRef.where("age", whereIn: [54, 60]).get();

    for (var user in result.docs) {
      debugPrint(user.data()["name"].toString());
    }
  }

  //Limit yaparak sorgulama
  void queryingDataThree() async {
    var userRef = firestore.collection("users").limit(2);
    var result = await userRef.where("age", whereIn: [54, 60]).get();

    for (var user in result.docs) {
      debugPrint(user.data().toString());
    }
  }

  //Siyah olanlar
  void queryingDataFour() async {
    var userRef = firestore.collection("users");
    var result = await userRef.where("colors", arrayContains: "Siyah").get();

    for (var user in result.docs) {
      debugPrint(user.data().toString());
    }
  }

  // Yaşa Göre Sıralama
  void queryingDataFive() async {
    var userRef = firestore.collection("users");
    var result = await userRef.orderBy("age", descending: true).get();

    for (var user in result.docs) {
      debugPrint(user.data().toString());
    }
  }

  void queryingDataSix() async {
    var userRef = firestore.collection("users");
    var result = await userRef.orderBy("name").startAt(["Gü"]).endAt([
      "Gü" + "\uf8ff",
    ]).get();

    for (var user in result.docs) {
      debugPrint(user.data().toString());
    }
  }
}
