import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importer Firestore pour interagir avec la base de données

class KetrikaPage extends StatelessWidget {
  const KetrikaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _entryController = TextEditingController();
    TextEditingController _exitController = TextEditingController();
    String? entry = '';
    String? exit = '';

    // Méthode pour mettre à jour la collection "presence" pour l'entrée
    Future<void> updateEntryPresence() async {
      String entryNumber =
          _entryController.text; // Récupérer le numéro d'entrée saisi

      // Vérifier si le numéro d'entrée existe dans la collection "eleves"
      QuerySnapshot eleveSnapshot = await FirebaseFirestore.instance
          .collection('eleves')
          .where('identifiant', isEqualTo: entryNumber)
          .get();

      // Si un document correspond au numéro d'entrée
      if (eleveSnapshot.docs.isNotEmpty) {
        // Récupérer les données de l'élève correspondant au numéro d'entrée
        String nom = eleveSnapshot.docs[0].get('nom');
        String prenom = eleveSnapshot.docs[0].get('prenom');
        String identifiant = eleveSnapshot.docs[0].get('identifiant');
        String filiere = eleveSnapshot.docs[0].get('filiere');
        String annee = eleveSnapshot.docs[0].get('annee');

        // Vérifier si une entrée correspondante existe déjà avec une heure de sortie vide
        QuerySnapshot entryCollection = await FirebaseFirestore.instance
            .collection('presence')
            .where('identifiant', isEqualTo: entryNumber)
            .where('heure_st', isEqualTo: '')
            .get();

        if (entryCollection.docs.isNotEmpty) {
          // Si une entrée correspondante avec une heure de sortie vide existe, mettre à jour seulement l'heure d'arrivée
          DocumentSnapshot entryDoc = entryCollection.docs.first;

          // Récupérer l'heure actuelle
          DateTime now = DateTime.now();
          String date = '${now.day}/${now.month}/${now.year}';
          String heureArrivee = '${now.hour}:${now.minute}:${now.second}';

          // Mettre à jour l'heure d'arrivée
          await FirebaseFirestore.instance
              .collection('presence')
              .doc(entryDoc.id)
              .update({'heure_arv': heureArrivee});

          // Afficher une boîte de dialogue pour indiquer que la mise à jour est terminée
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Mise à jour effectuée'),
                content: Text(
                    'L\'heure d\'arrivée a été mise à jour dans la collection "presence".'),
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
        } else {
          // Si aucune entrée correspondante avec une heure de sortie vide existe, ajouter une nouvelle entrée
          // Récupérer l'heure actuelle
          DateTime now = DateTime.now();
          String date = '${now.day}/${now.month}/${now.year}';
          String heureArrivee = '${now.hour}:${now.minute}:${now.second}';

          // Ajouter les données dans la collection "presence"
          await FirebaseFirestore.instance.collection('presence').add({
            'nom': nom,
            'prenom': prenom,
            'identifiant': identifiant,
            'filiere': filiere,
            'annee': annee,
            'date': date,
            'heure_arv': heureArrivee,
            'heure_st': '', // Initialiser l'heure de sortie comme vide
          });

          // Afficher une boîte de dialogue pour indiquer que la mise à jour est terminée
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Mise à jour effectuée'),
                content: Text(
                    'Les données ont été mises à jour dans la collection "presence".'),
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
      } else {
        // Afficher une boîte de dialogue si le numéro d'entrée n'existe pas dans la collection "eleves"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text("Le numéro d'entrée n'existe pas."),
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

    // Méthode pour mettre à jour la collection "presence" pour la sortie
    Future<void> updateExitPresence() async {
      String exitNumber =
          _exitController.text; // Récupérer le numéro de sortie saisi

      // Vérifier si le numéro de sortie existe dans la collection "presence"
      QuerySnapshot exitCollection = await FirebaseFirestore.instance
          .collection('presence')
          .where('identifiant', isEqualTo: exitNumber)
          .get();

      // Si un document correspond au numéro de sortie
      if (exitCollection.docs.isNotEmpty) {
        // Récupérer le premier document correspondant au numéro de sortie
        DocumentSnapshot firstDoc = exitCollection.docs.first;

        // Récupérer l'heure actuelle
        DateTime now = DateTime.now();
        String exitTime = '${now.hour}:${now.minute}:${now.second}';

        // Mettre à jour l'heure de sortie
        await FirebaseFirestore.instance
            .collection('presence')
            .doc(firstDoc.id)
            .update({
          'heure_st': exitTime,
        });

        // Afficher une boîte de dialogue pour indiquer que la mise à jour est terminée
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Mise à jour effectuée'),
              content: Text(
                  'L\'heure de sortie a été mise à jour dans la collection "presence".'),
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
      } else {
        // Afficher une boîte de dialogue si le numéro de sortie n'existe pas dans la collection "presence"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text("Le numéro de sortie n'est pas présent."),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mascareignes',
          style: TextStyle(
            color: Colors.blue, // Couleur bleue
            fontSize: 20, // Taille de la police
            fontWeight: FontWeight.bold, // Texte en gras
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input pour l'heure d'entrée
            TextFormField(
              controller: _entryController,
              decoration: InputDecoration(
                labelText: 'Entrée',
                prefixIcon: Icon(Icons.login), // Icône d'entrée
              ),
              onChanged: (value) {
                entry = value;
              },
            ),
            SizedBox(height: 16), // Espacement entre les champs
            // Input pour l'heure de sortie
            TextFormField(
              controller: _exitController,
              decoration: InputDecoration(
                labelText: 'Sortie',
                prefixIcon: Icon(Icons.logout), // Icône de sortie
              ),
              onChanged: (value) {
                exit = value;
              },
            ),
            SizedBox(height: 16), // Espacement entre les champs
            // Bouton de mise à jour pour l'entrée
            ElevatedButton(
              onPressed: () {
                if (entry == null || entry!.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erreur'),
                        content: Text("Veuillez saisir un numéro d'entrée."),
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
                } else {
                  // Vérifier et mettre à jour la collection "presence" pour l'entrée
                  updateEntryPresence();
                }
              },
              child: Text('Mise à jour (Entrée)'),
            ),
            SizedBox(height: 16), // Espacement entre les boutons
            // Bouton de mise à jour pour la sortie
            ElevatedButton(
              onPressed: () {
                if (exit == null || exit!.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erreur'),
                        content: Text("Veuillez saisir un numéro de sortie."),
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
                } else {
                  // Vérifier et mettre à jour la collection "presence" pour la sortie
                  updateExitPresence();
                }
              },
              child: Text('Mise à jour (Sortie)'),
            ),
          ],
        ),
      ),
    );
  }
}
