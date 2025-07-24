import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseapp/dataList.dart';
import 'package:firebaseapp/firebase_firestore_kullanimi.dart';
import 'package:firebaseapp/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  //Bunlar mutlaka olmak zorunda... Veri işlemleri için FireStore gibi...
  //firebase_options olmadan firebase işlemleri yapılmaz...
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: DataList());
  }
}

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  final String email = "kutluali@outlook.com";
  final String password = "yenisifre";
  late FirebaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((user) {
      if (user == null) {
        print("kullanıcı oturumu kapattı");
      } else {
        print(
          "Kullanıcı oturumu açtı ${user.email}, email durumu : ${user.emailVerified}",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FireBase"),
        backgroundColor: Colors.cyan.shade300,
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
                //create
                createUserEmailAndPassword();
              },
              child: Text(
                "Kayıt Ol",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 15),
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
                loginUserEmailAndPassword();
              },
              child: Text(
                "Giriş Yap",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.orangeAccent.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //create
                signOutUser();
              },
              child: Text(
                "Çıkış Yap",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 15),
            Divider(thickness: 1),
            SizedBox(height: 45),
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
                //create
                deleteUser();
              },
              child: Text(
                "Hesabı Sil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 15),
            Divider(thickness: 1),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.yellow.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(300, 45),
              ),
              onPressed: () {
                //create
                changePass();
              },
              child: Text(
                "Parola Değiştir",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(height: 15),
            Divider(thickness: 1),
            SizedBox(height: 15),
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
                //create
                changeEmail();
              },
              child: Text(
                "Email Değiştir",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var _myUser = _userCredential.user!;
      if (!_myUser.emailVerified) {
        _myUser.sendEmailVerification();
      }
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signOutUser() async {
    await auth.signOut();
  }

  void deleteUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.delete();
    } else {
      debugPrint("Önce Oturum Açmalısınız");
    }
  }

  void changePass() async {
    try {
      await auth.currentUser!.updatePassword("yebisifre");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        debugPrint("Tekrar oturum Açmalı");

        var credantial = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await auth.currentUser!.updatePassword("yenisifre");
        await auth.signOut();
        debugPrint(" Şifre güncellendi");
      } else {}
    }
  }

  void changeEmail() async {
    try {
      await auth.currentUser!.verifyBeforeUpdateEmail("kutluali@gmail.com");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        var credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        auth.currentUser!.reauthenticateWithCredential(credential);
        await auth.currentUser!.verifyBeforeUpdateEmail("hangedMail@gmail.com");
        await auth.signOut();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
