import 'package:flutter/material.dart';
import 'ihm/HomePage.dart';
//voici les principaux package extern utiliser pour le developpement
// peu utiliser dans cette application mais la package Path_provider perment d'enregistrer toute sorte de document
// https://pub.dev/packages/path_provider/install

// le package xml permet de au d'interpreter un fichier pour n'en sortir que les valeur
// https://pub.dev/packages/xml

// le package pdf permet de creer et d'editer un fichier pdf
// https://pub.dev/packages/pdf

//le package printing permet d'imprimer on de telecharger un pdf ou une page web
// https://pub.dev/packages/printing


// Au cours du projet deux nom on ete utilise pour parler des degre d'alcool
// le terme utiliser par les utilisateur est l'enfoncement, ils parlent d'enfoncement lu quand l'enfoncement est lu avec l'alcoometre
// l'enfoncement Reel quant a lui est l'enfoncement ramener a un temperature de 20 °C.

//je n'ai pris connaissance de ces terme qu'a la moitier du projet, avant cela
// on me parlai de degre Mesure ( degreM ou degreMesure pour les variable)
// et de degre Rectiefier (degreR ou degreRectifie pour les variable)
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: EcranHome(),
      theme: ThemeData(
        primaryColor: Colors.yellow[200],
        //accentColor: Colors.black
          brightness: Brightness.light,
      ),
    );
  }
}
