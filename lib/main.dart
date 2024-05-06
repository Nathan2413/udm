import 'package:flutter/material.dart';
import 'model.dart'; // Importez votre fichier model.dart
import 'package:firebase_core/firebase_core.dart'; // Importez Firebase Core
import 'firebase_options.dart'; // Importez vos options Firebase

void main() async {
  // Initialisez Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Université des Mascareignes',
      theme: ThemeData(
          // Configurez ici votre thème si nécessaire
          ),
      home:
          const StudentModel(), // Définissez le widget StudentModel comme écran d'accueil
    );
  }
}
