
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tab4dv2/metier/ConteneurVeille.dart';
import '../Xml/SauvPese.dart';
import '../Xml/FileUtils.dart';

//l'ecran 4DVeille est Utiliser pour lire les Pese des Journé anterieure.
//l'application va chercher la date demander dans le ficher Xml (nommé Donne-Campagne-<anneeDeDebut>-<anneeDeFin>
//puis Chaque pese sera Afficher dans le conteneur qui lui Corespond
class EcranVeille extends StatefulWidget{
  EcranVeille({Key key}) :super(key: key) ;

  @override
  _EcranVeille createState() => new _EcranVeille();
}

class _EcranVeille extends State<EcranVeille> {
  ConteneurVeille _vin, _bc,_vinSoir,_teteEtQueueSoir, _secondeSoir,_brouillisNuit,_brouillisJour,  _cuvierCharge, _teteEtQueue, _edv,
      _secondes, _brouillis, _trenteBc;
  SauvPese donneCampagne;
  DateTime dateJour;
  DateTime jourVerif;
  String _rendementChauffeNuit, _rendementChauffeJour, _rendementBonneChauffe;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vin = new ConteneurVeille('Vin', 'vinMatin');
    _bc = new ConteneurVeille('30BC', 'BCcharge');
    _cuvierCharge = new ConteneurVeille('Cuvier', 'Cuve');
    _teteEtQueueSoir = new ConteneurVeille('Tete & Queue', 'TetQSoir');
    _vinSoir = new ConteneurVeille('Vin','vinSoir');
    _brouillisJour = new ConteneurVeille('Brouillis Jour', '');
    _secondeSoir = new ConteneurVeille('Seconde','SecondeSoir');
    _brouillisNuit = new ConteneurVeille('Brouillis Nuit', 'BrouillisNuit');
    _teteEtQueue = new ConteneurVeille('Tete & Queue', 'TetQ');
    _edv = new ConteneurVeille('Eau de vie', 'EdV');
    _secondes = new ConteneurVeille('Seconde', 'Seconde');
    _brouillis = new ConteneurVeille('Brouillis', 'Brouillis');
    _trenteBc = new ConteneurVeille('30BC', 'BC');
    dateJour = new DateTime.now();
    readleFile();
    jourVerif = dateJour.subtract(new Duration(days: 1));
    _rendementChauffeNuit = '0.00';
    _rendementChauffeJour = '0.00';
    _rendementBonneChauffe = '0.00';

  }



  void readleFile() async {
    donneCampagne = new SauvPese(path: await FileUtils.readPeseSauv());
    setLesContainer();
    setState(() {});
  }

  //cette methode est celle qui va chercher dans le fichier les donne correspondante au conteneur et au jour place en parametre
  // puis après les Conteuneur inisialiser la methode appelle d'autre methode pour calculer les donnee non sauvegarder.
  setLesContainer()async{
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _vin);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _vinSoir);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _teteEtQueueSoir);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _secondeSoir);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _brouillisNuit);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _bc);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _teteEtQueue);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _edv);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _secondes);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _brouillis);
    donneCampagne.testread(DateFormat('dd/MM/yyyy').format(jourVerif), _trenteBc);
    setCuvierCharge();
    setBrouillisJour();
    setLesRendement();
  }

  void setCuvierCharge(){
    _cuvierCharge.setVolume((_vinSoir.getVolume() + _secondeSoir.getVolume() + _teteEtQueueSoir.getVolume()).toString());
    _cuvierCharge.setVolumeAp((_vinSoir.getVolumeAp() + _secondeSoir.getVolumeAp() + _teteEtQueueSoir.getVolumeAp()).toStringAsFixed(4));
    _cuvierCharge.setDegreR((_cuvierCharge.getVolumeAp()/_cuvierCharge.getVolume()*100).toStringAsFixed(1));
  }
  void setBrouillisJour(){
    _brouillisJour..setVolume((_brouillis.getVolume() - _brouillisNuit.getVolume()).toString());
    _brouillisJour..setVolumeAp((_brouillis.getVolumeAp() - _brouillisNuit.getVolumeAp()).toStringAsFixed(4));
    _brouillisJour.setDegreR((_brouillisJour.getVolumeAp()/_brouillisJour.getVolume()*100).toStringAsFixed(1));
  }
  void setLesRendement(){
    _rendementChauffeJour = (_brouillisJour.getVolumeAp()/_vin.getVolumeAp()*100).toStringAsFixed(1);
    _rendementChauffeNuit = (_brouillisNuit.getVolumeAp()/_cuvierCharge.getVolumeAp()*100).toStringAsFixed(1);
    _rendementBonneChauffe = ((_teteEtQueue.getVolumeAp()+_edv.getVolumeAp()+_secondes.getVolumeAp())/_bc.getVolumeAp()*100).toStringAsFixed(1);
  }
  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('bottom-sliver-list');

    return new Scaffold(

        appBar: AppBar(
          //backgroundColor: Colors.yellow[200],
          title : Text('${DateFormat('dd/MM/yyyy').format(jourVerif)}    Soir',style : TextStyle( color: Colors.red[900])),
        ),
        body: Center(
          //le customscroolviex permet de faire defiler l'encran de haut en bas
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
                                border: Border.all(color: Colors.black, width: 2,),
                              ),
                              child: Text('Mise en chaudière',
                                textAlign: TextAlign.center,
                                style : TextStyle(
                                    fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                        //cette Ligne contient les Conteneur utiliser pour les Charges des Chaudiere.
                        Row(
                          children: <Widget>[
                            _vin.buildContainer(context),
                            _bc.buildContainer(context),
                            _cuvierCharge.buildContainer(context),
                          ],
                        ),
                        //cette ligne est le Descriptife du contenuer _cuvierCharge qui n'est que la somme de ces trois conteneur.
                        Row(
                          children: [
                            _vinSoir.buildContainer(context),
                            _teteEtQueueSoir.buildContainer(context),
                            _secondeSoir.buildContainer(context),
                            ],
                        ),
                        ////cette ligne et l'entete des bonne chauffe
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
                              margin: EdgeInsets.only(top: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 36, ),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                //shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 2,),

                              ),
                              child: Text('Alcool obtenue : Bonne Chauffe',
                                textAlign: TextAlign.center,
                                style : TextStyle(
                                    fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                        // Cette Ligne designe le premier ensemble des pesée de la journée. (T&Q, EDV, Secondes).
                        Row(
                          children: <Widget>[
                            _teteEtQueue.buildContainer(context),
                            _edv.buildContainer(context),
                            _secondes.buildContainer(context),
                          ],
                        ),
                        // Cette Ligne designe le deuxieme ensemble des pesée de la journée. (brouillis , brouillisNuit et BrouillisJour).
                        //les Brouillis jour sont obtenue en faisant la differrence entre les brouillis,  les brouillisNuit et les Seconde.
                        Row(
                          children: <Widget>[
                            _brouillis.buildContainer(context),
                            _brouillisNuit.buildContainer(context),
                            _brouillisJour.buildContainer(context),
                            //Text('un texte : $test'),
                          ],
                        ),
                        // Cette Ligne designe le deuxieme ensemble des pesée de la journée. (la cuve30BC et les calcul de rendemant);
                        Row(
                          children: [
                            _trenteBc.buildContainer(context),
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height / 3,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 5.5,
                              margin: EdgeInsets.only(top: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 36, left: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 18),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                //shape: BoxShape.circle,
                                border: Border.all(color: Colors.black, width: 1,),
                              ),
                              child: Column(children: <Widget>[
                                Text('Rendement',
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                ),
                                Text('rendement vin jour : $_rendementChauffeJour %'),
                                Text('rendement vin nuit : $_rendementChauffeNuit %'),
                                Text('rendement bonne chauffe : $_rendementBonneChauffe %')
                              ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment : MainAxisAlignment.spaceBetween,
                          children: [
                            //lorsque un des deux bouton est pressed la variable jourVerif change pour devenire la date precedante ou la date suivante
                            //en fonction du boutton pressed
                          RaisedButton(
                            onPressed:  /*( jourVerif.subString(0,06) == '01/10/' ? null :*/ (){

                              jourVerif = jourVerif.subtract(new Duration(days: 1));
                                setState(() {
                                  setLesContainer();
                                });
                            },

                            child : Text('jour precedant'),),
                          RaisedButton(
                            onPressed:  (){
                              jourVerif = jourVerif.add(new Duration(days: 1));
                              setState(() {
                              setLesContainer();
                              });
                            },
                            child : Text('jour suivant'),
                          ),
                        ],
                        ),
                      ],
                    );
                  },
                  childCount: 1, //permet de crée qu'un seul 'ecran' de le scrollView
                ),
              ),
            ],
          ),
        ),

      );
  }
}