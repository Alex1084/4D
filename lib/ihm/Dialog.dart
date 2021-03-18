import 'package:flutter/material.dart';
//cette classe est une classe static elle a pour but de "zoomer" les info d'un Conteneur de Pese en ouvrant un dialog
// chaque Text equivaut a une variable du conteneur
class LesDialog{
  static Future<Null> dialogZoom(BuildContext context, String titre, String volume, String degreRectifie, String volumeAp,  String temperature, String degreMesure,)  async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('${titre}'),
            children: <Widget>[

              Text(' Volume : ${volume}',
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 32
                ),),
              Text('enfoncement reel : ${degreRectifie}',
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 32
                ),),
              Text('Volume AP : ${volumeAp}',
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 32
                ),),
              Text('temperature : ${temperature}',
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 32
                ),),
              Text('enfoncement lu : ${degreMesure}',
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 32
                ),),
              RaisedButton(onPressed: (){

                Navigator.of(context).pop();
              },
                  child: Text('Ok')),
            ],
          );
        }

    );

  }

 /* static Future<Null> dialogZoomBrouillis(BuildContext context,)  async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('\${}'),
            children: <Widget>[
              RaisedButton(onPressed: (){

                Navigator.of(context).pop();
              },
                  child: Text('Ok')),
            ],
          );
        }

    );

  }*/
  /*static Future<Null> dialogZoomCuvier(BuildContext context)  async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('\${}'),
            children: <Widget>[
              Text('${}'),
              RaisedButton(onPressed: (){

                Navigator.of(context).pop();
              },
                  child: Text('Ok')),
            ],
          );
        }

    );

  }
*/
}