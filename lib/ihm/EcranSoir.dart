import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:tab4dv2/metier/ConteneurVeille.dart';
import '../Xml/SauvPese.dart';
import '../Xml/FileUtils.dart';
import '../metier/ConteneurJour.dart';
import 'package:flutter/material.dart';

//la structure de cette ecrant est très similaire a l'ecran de nuit

//cette ecran est utiliser par les distilateur travaillant de journee,
// le distilateur en chef remplie les conteneur vin et bc pour le distilateur
// ensuite lorque les alcool obtenue sont mesure les distilateur saisie le conteneur concernant le type "d'alcool"
// et enregistre les données de cette ecran une fois que tout a été remplis
class EcranJournee extends StatefulWidget{

  EcranJournee({Key key}) : super(key: key);

  @override
  _EcranJournee createState() => new _EcranJournee();
}

class _EcranJournee extends State<EcranJournee>{
  JourConteneur _vin, _teteEtQueue, _edv, _secondes, _brouillis, _trenteBc; //ces conteneur sont des Statefullwidget et sont donc implementer directement dans l'interface en appelent l'objet
  ConteneurVeille _bc; // ce conteneur doit afficher les donne de la cuve 30BC qui a ete pese la Veille

  SauvPese enregistreJourne;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._vin = new JourConteneur('Vin', 'vinMatin', Colors.grey,);
    this._teteEtQueue = new JourConteneur('Tete & Queue','TetQ', Colors.grey,);
    this._edv = new JourConteneur('Eau de vie','EdV', Colors.grey,);
    this._secondes = new JourConteneur('Secondes','Seconde', Colors.grey,);
    this._brouillis = new JourConteneur('Brouillis','Brouillis', Colors.grey,);
    this._trenteBc = new JourConteneur('30BC','BC', Colors.grey,);
    _bc = new ConteneurVeille('30BC', 'BC');
    readCache();
    readBc();
  }

  void readBc() async {
    SauvPese readBc;
    readBc = new SauvPese(path: await FileUtils.readPeseSauv());
    readBc.setRead(DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(Duration(days: 1))), _bc);
    setState(() {});
  }


  // cette methode initialise d'abord l'objet enrigistre donne (qui va donne une "valeur" au document xml)
  // puis elle insert les conteneur dans un Dictionnaire pour ensuite les enregistre grace a la classe SauvPese
  void enregistrer() async{
    enregistreJourne = new SauvPese(path: await FileUtils.readPeseSauv());
    String _text;
    Map<int, JourConteneur> _mapEnreg = new Map<int, JourConteneur>();
    _mapEnreg[1] = _vin;
    _mapEnreg[4] = _teteEtQueue;
    _mapEnreg[5] = _edv;
    _mapEnreg[6] = _secondes;
    _mapEnreg[7] = _brouillis;
    _mapEnreg[8] = _trenteBc;
    enregistreJourne.enregJour(enregistreJourne.builder, DateFormat('dd/MM/yyy').format(DateTime.now()), _mapEnreg);
    _text = enregistreJourne.sauvegarde.toXmlString(pretty: true, indent: '\t' );
    FileUtils.writePeseSauv(_text);


  }
  // cette methode lis la memoire cache pour ensuite atribuer au conteneur qui a deja été saisie
  // les valeur qui on ete oublier par le programme (a cause d'un changement d'ecran)
  void readCache()async{

    String _cacheText;
    _cacheText = await FileUtils.readCacheJour();
    if (_cacheText == ''){
      String textInit = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n<uneJourne>\n</uneJourne>';
      FileUtils.writeCacheJour(textInit);
      JourConteneur.initEnregCache(textInit);

    }
    else{
      JourConteneur.enregCache.readCacheXml(_vin);
      JourConteneur.enregCache.readCacheXml(_teteEtQueue);
      JourConteneur.enregCache.readCacheXml(_edv);
      JourConteneur.enregCache.readCacheXml(_brouillis);
      JourConteneur.enregCache.readCacheXml(_secondes);
      JourConteneur.enregCache.readCacheXml(_trenteBc);
      //_vin.setStateContainer();
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context){
    //enregistreJourne.testread(DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(Duration(days: 1))), _bc);
    const Key centerKey = ValueKey('bottom-sliver-list');
    //feuilleBlanche.generationFeuilleBlanche();
    return new Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          //backgroundColor: Colors.yellow[200],
          title : Text('4D Journée',style : TextStyle( color: Colors.red[900])),
    ),
        body: Center(

          child:CustomScrollView(
            center: centerKey,
            slivers: <Widget>[
            SliverList(
              key: centerKey,
              delegate: SliverChildBuilderDelegate(
              ( BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                  //cette Ligne designe le Titre du tableau (Date).
                  Row(
                    children: <Widget>[
                      Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 12,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            //shape: BoxShape.circle,
                          ),
                          child: Text('${DateFormat('dd/MM/yyyy').format(DateTime.now())} Journée',
                            textAlign: TextAlign.center,
                            style : TextStyle(
                            fontSize: 32),
                          )
                      ),
                    ],
                  ),
                  //ligne pour cadre du Vin
                  Row(
                    children: <Widget>[
                      Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 12,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            //shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2,),
                          ),
                          child: Text('Mise en chaudière : ce Matin',
                            textAlign: TextAlign.center,
                            style : TextStyle(
                                fontSize: 24),
                          ),
                      ),
                    ],
                  ),
                    // cette ligne concerne la mise en chaudiere ce sont ces conteneur qui sont saisie par le distilateur en chef
                  Row(
                    children: <Widget>[
                      _vin,
                      _bc.buildContainer(context),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height/12,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.only(bottom: 0, top: MediaQuery
                              .of(context)
                              .size
                              .width / 36, right: 0, left: 0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            //shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2,),

                          ),
                          child: Text('Alcool obtenue : Aujourd\'hui',
                            textAlign: TextAlign.center,
                            style : TextStyle(
                                fontSize: 24),
                          ),
                      ),
                    ],
                  ),
                    // cette ligne concerne les conteneur saisie par le distilateur après ces pesee (T&Q, EDV, brouille).
                  Row(
                    children: <Widget>[
                      _teteEtQueue,
                      _edv,
                      _brouillis,
                    ],
                  ),
                    // cette ligne concerne les conteneur saisie par le distilateur après ces pesee (seconde et la cuve 30BC)
                  Row(
                    children: <Widget>[
                      _secondes,
                      _trenteBc,
                    ],
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // appelle la methode enregistre et efface les donnees de la memoire cache de jour puis affiche un pop up pour confirmer l'enregistrement
                        RaisedButton(onPressed: () {
                            enregistrer();
                            FileUtils.writeCacheJour('');
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: Text('Sauvegarde'),
                                content: Text('les Données ont été enregister avec succés'),
                                actions: [
                                  FlatButton(onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                      child: Text('OK')
                                  )
                                ],
                              );
                            }
                            );
                            setState(() {
                               widget.createState();
                            });

                        },
                        child: Text('enregistrer'),)
                      ],
                    ),

                ],
              );
        },
          childCount: 1,
    ),
    ),
          ],
        ),
        ),

    );
  }
}