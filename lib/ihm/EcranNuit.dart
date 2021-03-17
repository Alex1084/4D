import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Xml/FileUtils.dart';
import '../Xml/SauvPese.dart';

import '../metier/ConteneurJour.dart';

//la structure de cette ecrant est très similaire a l'ecran de Jour

//cette ecran est utiliser par les distilateur travaillant de nuit,
// le distilateur en chef remplie les conteneur vin secondevin et teteEtQueuevin pour le distilateur
// ensuite lorque les brouillis obtenue sont mesure les distilateur saisie le conteneur brouillis nuit et enregistre les donnée de cette ecran
class EcranNuit extends StatefulWidget{
  @override
  _EcranNuit createState() => new _EcranNuit();
}

class _EcranNuit extends State<EcranNuit>{
  JourConteneur _vin, _secondeVin, _teteEtQueueVin, _BrouillisNuit; //ces conteneur sont des Statefullwidget et sont donc implementer directement dans l'interface en appelent l'objet
  double _totalVolume, _totalVolumeAp, _rendement;
  SauvPese enregistreNuit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._vin = new JourConteneur('Vin', 'vinSoir');
    this._secondeVin = new JourConteneur('Secondes','SecondeSoir');
    this._teteEtQueueVin = new JourConteneur('Tete & Queue','TetQSoir');
    this._BrouillisNuit = new JourConteneur('Brouillis Nuit', 'BrouillisNuit');
    _totalVolumeAp = 1;
    _totalVolume = 1;
    _rendement = 0;
    readCache();

  }

  // cette methode insert les conteneur dans un Dictionnaire pour ensuite les enregistre grace a la classe SauvPese
  void enregistrer() async{
    Map<int, JourConteneur> _mapEnreg = new Map<int, JourConteneur>();
    String text;
    enregistreNuit = new SauvPese(path: await FileUtils.readPeseSauv());
    _mapEnreg[1] = _vin;
    _mapEnreg[2] = _secondeVin;
    _mapEnreg[3] = _teteEtQueueVin;
    _mapEnreg[4] = _BrouillisNuit;
    enregistreNuit.enregJour(enregistreNuit.builder, DateFormat('dd/MM/yyyy').format(DateTime.now()), _mapEnreg);
    text = enregistreNuit.sauvegarde.toXmlString(pretty: true, indent: '\t' );
    FileUtils.writePeseSauv(text);


  }

  // cette methode lis la memoire cache pour ensuite atribuer au conteneur qui a deja été saisie
  // les valeur qui on ete oublier par le programme (a cause d'un changement d'ecran)
  void readCache()async{
    String _cacheText;
    _cacheText = await FileUtils.readCacheNuit();
    //_cacheText = '';
    if (_cacheText == ''){
      String textInit = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n<uneJourne>\n</uneJourne>';
      FileUtils.writeCacheNuit(textInit);
      JourConteneur.initEnregCache(textInit);
    }
    else{
      JourConteneur.enregCache.readCacheXml(_vin);
      JourConteneur.enregCache.readCacheXml(_secondeVin);
      JourConteneur.enregCache.readCacheXml(_teteEtQueueVin);
      JourConteneur.enregCache.readCacheXml(_BrouillisNuit);
    }
  }
  @override
  Widget build(BuildContext context){
    const Key centerKey = ValueKey('bottom-sliver-list');
    return Scaffold(
      appBar : AppBar(
        title : Text('4D Nuit',style : TextStyle( color: Colors.red[900])),
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
                        color: Colors.black12,
                        //shape: BoxShape.circle,
                      ),
                      child: Text('${DateFormat('dd/MM/yyyy').format(DateTime.now())}    Nuit',
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
                      color: Colors.black12,
                      //shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2,),
                    ),
                    child: Text('Mise en chaudière : Hier Soir',
                      textAlign: TextAlign.center,
                      style : TextStyle(
                          fontSize: 24),
                    ),
                  ),
                ],
              ),
              // cette ligne concerne la mise en chaudiere ce sont ces conteneur qui sont saisie par le distilateur en chef
              Row(
                children : [
                _vin,
                _secondeVin,
                _teteEtQueueVin,

                //ce conteneur a pour but d'indiquer la somme des trois conteneur si dessus
                // ces donnee ne sont pas enregistrer car elles sont purement a tritre informatif pour le distilateur
                // de plus elles peuvent etre recalculer grace au trois conteneur si dessus
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 5.5,
                  margin: EdgeInsets.only(bottom: 0, top: MediaQuery
                      .of(context)
                      .size
                      .width / 36, right: 0, left: MediaQuery
                      .of(context)
                      .size
                      .width / 18),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black, width: 1,),
                  ),
                  child: Column(children: <Widget>[
                    Text('Total',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    Text('Volume :  ${this._totalVolume}',
                      style: TextStyle(
                          fontSize: 18
                      ),), //Designe le Volume Mersure
                    Text('Degre : ${(this._totalVolumeAp/this._totalVolume * 100).toStringAsFixed(1)}',
                      style: TextStyle(
                          fontSize: 18
                      ),), //Designe le Degré Rectifier
                    Text('Volume AP : ${(this._totalVolumeAp).toStringAsFixed(4)}',
                      style: TextStyle( //Designe le Volume D'alcool Pur
                          fontSize: 18
                      ),
                    ),
                    RaisedButton(onPressed: (){
                      setState(() {
                        this._totalVolume = this._teteEtQueueVin.getVolume() + this._secondeVin.getVolume() + this._vin.getVolume();
                        this._totalVolumeAp = double.parse(this._teteEtQueueVin.getVolumeAp()) + double.parse(this._secondeVin.getVolumeAp()) + double.parse(this._vin.getVolumeAp());
                      });

                    },
                      child : Text('calculer'),)
                  ],
                  ),
                ),
              ],),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .size
                        .width / 36,),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 12,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      //shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2,),
                    ),
                    child: Text('Brouillis Obtenue cette Nuit',
                      textAlign: TextAlign.center,
                      style : TextStyle(
                          fontSize: 24),
                    ),
                  ),
                ],
              ),
              // cette ligne concerne les conteneur saisie par le distilateur après ces pesee
              Row(
                children: [
                  _BrouillisNuit,
                ],
              ),

              // appelle la methode enregistre et efface les donnees de la memoire cache de nuit puis affiche un pop up pour confirmer l'enregistrement
              RaisedButton(onPressed: () {
                  enregistrer();
                  FileUtils.writeCacheNuit('');
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text('Sauvegarde'),
                      content: Text('les Données ont été enregister avec succés'),
                      actions: [
                        FlatButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text('OK'))
                      ],
                    );
                  }
                  );

              },
                child: Text('enregistrer'),)
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