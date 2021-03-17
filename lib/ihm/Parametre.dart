import 'package:flutter/material.dart';
import 'package:tab4dv2/Xml/FileUtils.dart';
import 'package:intl/intl.dart';


//l'ecran de parametre est utiliser pour creer un nouveau fichier a chaque debut de campagne
// le fichier est nommé en fonction de l'année actuelle et l'anne suivante.
class EcranParam extends StatefulWidget{
  @override
  _EcranParam createState() => new _EcranParam();
}

class _EcranParam extends State<EcranParam>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title : Text('Parametre'),
      ),
      body: Center(
        child: Column(
        children: <Widget>[
          RaisedButton(
          onPressed: (){
            FileUtils.annee = int.parse(DateFormat('yyyy').format(DateTime.now()));
            FileUtils.anneeproch = FileUtils.annee+1;
            FileUtils.writePeseSauv(
                '''<?xml version="1.0"?>
<peseCampagne>
</peseCampagne>''');
          },
          child: Text('NouvelleCampagne'),
        ),
        ],
      ),
      ),
    );
  }
}