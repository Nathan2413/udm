import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importer FirebaseAuth
import 'eleve.dart'; // Importez le fichier eleve.dart
import 'admin/dashboard.dart';

class StudentModel extends StatelessWidget {
  const StudentModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Détection de la plateforme cible
    bool isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      // Interface utilisateur pour les appareils mobiles
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Grand icône d'étudiant avec un espacement supplémentaire en haut
              SizedBox(
                height: 40,
                child: Icon(
                  Icons.school,
                  size: 250,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 250), // Espacement entre l'icône et la citation
              // Citation sur l'éducation avec une taille de police plus grande
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '"L\'éducation est l\'arme la plus puissante qu\'on puisse utiliser pour changer le monde."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 80), // Espacement entre la citation et le bouton
              // Bouton pour s'enregistrer
              ElevatedButton(
                onPressed: () {
                  // Diriger vers la page eleve.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ElevePage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue), // Couleur de fond du bouton
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Couleur du texte du bouton
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
                child: Text(
                  'S\'enregistrer',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Interface utilisateur pour les écrans larges (web)
      return Scaffold(
        body: Row(
          children: [
            // Grid gauche similaire à la version mobile
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Grand icône d'étudiant avec un espacement supplémentaire en haut
                    SizedBox(
                      height: 40,
                      child: Icon(
                        Icons.school,
                        size: 250,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                        height: 250), // Espacement entre l'icône et la citation
                    // Citation sur l'éducation avec une taille de police plus grande
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '"L\'éducation est l\'arme la plus puissante qu\'on puisse utiliser pour changer le monde."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            80), // Espacement entre la citation et le bouton
                  ],
                ),
              ),
            ),
            // Grid droit pour le formulaire de connexion
            Expanded(
              child: Center(
                child: LoginForm(), // Afficher le formulaire de connexion
              ),
            ),
          ],
        ),
      );
    }
  }
}

// Formulaire de connexion
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Méthode pour la connexion avec Firebase
  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Authentification réussie, naviguer vers la page ElevePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (error) {
      // Gestion des erreurs d'authentification
      print("Erreur d'authentification: $error");
      // Afficher une boîte de dialogue d'erreur
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text("Adresse e-mail ou mot de passe incorrect."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Grand titre "Login"
          Text(
            'Login',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Couleur du titre
            ),
          ),
          SizedBox(
              height:
                  20), // Espacement entre le titre et le champ de saisie pour l'email
          // Champ de saisie pour l'email
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          SizedBox(height: 20), // Espacement entre les champs de saisie
          // Champ de saisie pour le mot de passe
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Mot de passe'),
            obscureText: true, // Pour masquer le texte saisi
          ),
          SizedBox(
              height: 20), // Espacement entre les champs de saisie et le bouton
          // Bouton de connexion
          ElevatedButton(
            onPressed: _login, // Appeler la méthode de connexion
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blue), // Couleur de fond du bouton
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white), // Couleur du texte du bouton
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            child: Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}
