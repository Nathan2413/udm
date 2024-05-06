import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importer le package Firestore

class ElevePage extends StatefulWidget {
  const ElevePage({Key? key}) : super(key: key);

  @override
  _ElevePageState createState() => _ElevePageState();
}

class _ElevePageState extends State<ElevePage> {
  bool _isFingerprintAuthenticated = false;
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire

  TextEditingController _identifiantController = TextEditingController();
  TextEditingController _nomController = TextEditingController();
  TextEditingController _prenomController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _anneeController = TextEditingController();

  String _selectedFiliere = ''; // Filière sélectionnée dans le dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Définir l'appBar comme null
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assigner la clé du formulaire
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(
                            context); // Pour revenir à l'écran précédent
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ), // Espacement entre l'icône retour et le titre
                    // Ajouter un padding en bas du titre pour le placer un peu plus haut
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Mascareignes',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Couleur du titre
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height:
                        16), // Espacement entre le titre et le champ de saisie
                // Champ de saisie pour l'identifiant
                TextFormField(
                  controller: _identifiantController,
                  decoration: InputDecoration(labelText: 'Identifiant'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre identifiant';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Espacement entre les champs de saisie
                // Champ de saisie pour le nom
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre nom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Espacement entre les champs de saisie
                // Champ de saisie pour le prénom
                TextFormField(
                  controller: _prenomController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre prénom';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Espacement entre les champs de saisie
                // Champ de saisie pour l'email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Espacement entre les champs de saisie
                // Champ de sélection pour la filière
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Filière'),
                  items: [
                    DropdownMenuItem(
                        child: Text('Informatique Appliquée'),
                        value: 'Informatique Appliquée'),
                    DropdownMenuItem(
                        child: Text('Bâtiment Travaux Publics'),
                        value: 'Bâtiment Travaux Publics'),
                    DropdownMenuItem(
                        child: Text('Génie Mécanique'),
                        value: 'Génie Mécanique'),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFiliere = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez sélectionner une filière';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Espacement entre les champs de saisie
                // Champ de saisie pour l'année
                TextFormField(
                  controller: _anneeController,
                  decoration: InputDecoration(labelText: 'Année'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir l\'année';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16), // Espacement entre les champs de saisie
                // Bouton pour scanner empreinte digitale
                IconButton(
                  icon: Icon(
                    _isFingerprintAuthenticated
                        ? Icons.fingerprint_rounded
                        : Icons.fingerprint_outlined,
                    color: _isFingerprintAuthenticated
                        ? Colors.red
                        : null, // Couleur de l'icône en rouge si authentifié
                    size: 80, // Taille de l'icône
                  ),
                  onPressed: () async {
                    // Logique pour scanner empreinte digitale
                    bool authenticated = await _scanFingerprint();
                    setState(() {
                      _isFingerprintAuthenticated = authenticated;
                    });
                  },
                ),
                SizedBox(
                    height:
                        26), // Espacement entre le scanner d'empreinte et le bouton d'enregistrement
                // Bouton pour enregistrer les informations
                ElevatedButton(
                  onPressed: () async {
                    // Valider le formulaire avant d'enregistrer
                    if (_formKey.currentState!.validate()) {
                      // Envoi des données à Firestore
                      await _sendDataToFirestore();
                      // Effacer les champs du formulaire après l'enregistrement
                      _identifiantController.clear();
                      _nomController.clear();
                      _prenomController.clear();
                      _emailController.clear();
                      _anneeController.clear();
                      setState(() {
                        _selectedFiliere = '';
                      });
                    }
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fonction pour simuler le scan d'empreinte digitale
  Future<bool> _scanFingerprint() async {
    // Ici, vous pouvez implémenter la logique de vérification de l'empreinte digitale
    // Cette fonction doit retourner true si l'empreinte digitale est authentifiée avec succès
    // Dans cet exemple, nous attendons simplement 5 secondes puis retournons true
    await Future.delayed(Duration(seconds: 5));
    return true;
  }

  // Fonction pour envoyer les données à Firestore
  Future<void> _sendDataToFirestore() async {
    // Créer un objet de données à envoyer
    Map<String, dynamic> userData = {
      'identifiant': _identifiantController.text,
      'nom': _nomController.text,
      'prenom': _prenomController.text,
      'email': _emailController.text,
      'filiere': _selectedFiliere,
      'annee': _anneeController.text,
      'empreinte': _isFingerprintAuthenticated,
    };

    // Envoyer les données à Firestore
    try {
      await FirebaseFirestore.instance.collection('eleves').add(userData);
      print('Données envoyées avec succès à Firestore');
    } catch (error) {
      print('Erreur lors de l\'envoi des données à Firestore: $error');
    }
  }
}
