import 'package:flutter/material.dart';
import '../model.dart';
import 'grid/ajou_admin.dart'; // Importer la page AjouterAdminPage
import 'grid/list_admin.dart'; // Importer la page ListAdmin
import 'grid/list_etu.dart'; // Importer la page ListEtudiant

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget _currentWidget =
      SizedBox(); // Widget actuel à afficher dans le côté droit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // En-tête avec ombre en bas
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Titre du projet "Mo Belle" avec un padding à gauche
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(
                    'Mascareignes',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 48, 168, 238),
                      shadows: [
                        Shadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                // Texte "Administrateur"
                Text(
                  'Administrateur',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                // Icône de déconnexion
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentModel(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Ombre gris-noir
          Container(
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Grid à gauche
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ExpansionTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            'Administrateur',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          tilePadding: EdgeInsets.only(left: 20),
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.add),
                              title: Text(
                                'Ajouter un administrateur',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Naviguer vers la page AjouterAdminPage sur le grid droit
                                setState(() {
                                  _currentWidget = AjouterAdminPage();
                                });
                              },
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.only(left: 40),
                              leading: Icon(Icons.list),
                              title: Text(
                                'Tous les administrateurs',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              onTap: () {
                                // Naviguer vers la page ListAdmin sur le grid droit
                                setState(() {
                                  _currentWidget = ListAdmin();
                                });
                              },
                            ),
                          ],
                        ),
                        ListTile(
                          leading: Icon(Icons.people),
                          title: Text(
                            'Tous les étudiants',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onTap: () {
                            // Naviguer vers la page ListEtudiant sur le grid droit
                            setState(() {
                              _currentWidget = ListEtudiant();
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.check),
                          title: Text(
                            'Présence',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onTap: () {
                            // Action lorsque "Présence" est tapée
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Grid à droite
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: _currentWidget,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
