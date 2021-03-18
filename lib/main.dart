import 'package:flutter/material.dart';
import 'ihm/HomePage.dart';

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
          //brightness: Brightness.dark,
      ),
    );
  }
}
