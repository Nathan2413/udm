import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListEtudiant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les listes des étudiants',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              _buildEtudiantList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEtudiantList(BuildContext context) {
    double tableWidth =
        MediaQuery.of(context).size.width * 0.9; // 90% de la largeur de l'écran

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('eleves')
          .orderBy('identifiant')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final etudiants = snapshot.data!.docs;

        return SizedBox(
          width: tableWidth,
          child: DataTable(
            columnSpacing: 20,
            columns: [
              DataColumn(label: Text('Identifiant')),
              DataColumn(label: Text('Nom')),
              DataColumn(label: Text('Prénom')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Filière')),
              DataColumn(label: Text('Année')),
              DataColumn(label: Text('Action')),
            ],
            rows: etudiants.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final identifiant = data['identifiant'];
              final nom = data['nom'];
              final prenom = data['prenom'];
              final email = data['email'];
              final filiere = data['filiere'];
              final annee = data['annee'];

              return DataRow(cells: [
                DataCell(Text(identifiant.toString())),
                DataCell(Text(nom)),
                DataCell(Text(prenom)),
                DataCell(Text(email)),
                DataCell(Text(filiere)),
                DataCell(Text(annee.toString())),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, nom, prenom);
                    },
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String nom, String prenom) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation de suppression"),
          content: Text("Souhaitez-vous supprimer $nom $prenom ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Non"),
            ),
            TextButton(
              onPressed: () {
                // Supprimer l'élément de la base de données
                FirebaseFirestore.instance
                    .collection('eleves')
                    .where('nom', isEqualTo: nom)
                    .where('prenom', isEqualTo: prenom)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.delete();
                  });
                });
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text("Oui"),
            ),
          ],
        );
      },
    );
  }
}
