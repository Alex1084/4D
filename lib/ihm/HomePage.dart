import 'package:apllication_4d/Xml/FileUtils.dart';
import 'package:flutter/material.dart';
import 'EcranJournee.dart';
import 'EcranNuit.dart';
import 'EcranVeille.dart';
import 'Parametre.dart';


//cette HomePage est faite pour Naviguer entre les 3 ecran (ecranVeille, ecranNuit et EcranJournee) avec la bar de navigation

class EcranHome extends StatefulWidget{
  @override
  _EcranHome createState() => new _EcranHome();
}

class _EcranHome extends State<EcranHome>{
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  //les 3 ecran sont contenue dans une list et lorsque l'utilisateur appui sur a item de la bar alors la varible selectedIdex change de Numero
  //puis le widget se trouvent au numero de l'index est appeler pour etre afficher.
  List<Widget> tabs = [
    EcranVeille(),
    EcranNuit(),
    EcranJournee(),
  ];

  //à l'ouverture de l'application la HomePage reinitialise les memoire cache car sinon une exception est créer et les fichier devienne inutilisable
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileUtils.writeCacheJour('');
    FileUtils.writeCacheNuit('');

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: tabs[_selectedIndex], //appelle de l'ecran en question
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.yellow[200],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              label: 'Veil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nightlight_round),
              label: 'Nuit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              label: 'Journée',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red[900],
          onTap: _onItemTapped,
        ),

      //le floating Action Button situer en haut a gauche de l'ecran sert a ouvrir l'ecrant de parametre
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings),
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return EcranParam();
          } ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );

  }
}
