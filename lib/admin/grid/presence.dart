import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importer Firestore pour interagir avec la base de données

class PresencePage extends StatelessWidget {
  const PresencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Les listes des étudiants présents',
          style: TextStyle(fontWeight: FontWeight.bold), // Titre en gras
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('presence')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des données'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> presenceList = snapshot.data!.docs.reversed
              .toList(); // Inverser l'ordre des éléments

          return Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nom')),
                  DataColumn(label: Text('Prénom')),
                  DataColumn(label: Text('Identifiant')),
                  DataColumn(label: Text('Filière')),
                  DataColumn(label: Text('Année')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Heure arrivée')),
                  DataColumn(label: Text('Heure sortie')),
                ],
                rows: presenceList.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return DataRow(cells: [
                    DataCell(Text(data['nom'] ?? '-')),
                    DataCell(Text(data['prenom'] ?? '-')),
                    DataCell(Text(data['identifiant'] ?? '-')),
                    DataCell(Text(data['filiere'] ?? '-')),
                    DataCell(Text(data['annee'] ?? '-')),
                    DataCell(Text(data['date'] ?? '-')),
                    DataCell(Text(data['heure_arv'] ?? '-')),
                    DataCell(Text(data['heure_st'] ?? '-')),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
