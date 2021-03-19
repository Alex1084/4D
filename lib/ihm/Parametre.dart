import 'package:apllication_4d/Xml/FileUtils.dart';
import 'package:flutter/material.dart';



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
        title : Text('Paramètre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
          onPressed: (){

            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text('Nouvelle campagne'),
                content: Text('Cette action ne doit être utilisée que en début de campagne afin de créer un nouveau fichier de sauvegarde.\n Etes vous sûr de vouloir créer un nouveau fichier ?'),
                actions: [
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                      child: Text('Annuler')
                  ),
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                      child: Text('OK')
                  ),
                ],
              );
            }
            );
            FileUtils.writePeseSauv('<?xml version="1.0"?>\n<peseCampagne>\n</peseCampagne>');
          },
          child: Text('NouvelleCampagne'),
        ),
        ],
      ),
      ),
    );
  }
}