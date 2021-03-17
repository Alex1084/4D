import 'dart:ui';
import 'package:intl/intl.dart';
import '../Xml/SauvPese.dart';
import '../Xml/FileUtils.dart';
import '../metier/ConteneurJour.dart';
import 'package:flutter/material.dart';




class EcranJournee extends StatefulWidget{

  EcranJournee({Key key}) : super(key: key);

  @override
  _EcranJournee createState() => new _EcranJournee();
}

class _EcranJournee extends State<EcranJournee>{
  JourConteneur _vin, _teteEtQueue, _edv, _secondes, _brouillis, _trenteBc;
  JourConteneur _bc;

  SauvPese enregistreJourne;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initEnregistreJourne();
    this._vin = new JourConteneur('Vin', 'vinMatin');
    this._teteEtQueue = new JourConteneur('Tete & Queue','TetQ');
    this._edv = new JourConteneur('Eau de vie','EdV');
    this._secondes = new JourConteneur('Secondes','Seconde');
    this._brouillis = new JourConteneur('Brouillis','Brouillis');
    this._trenteBc = new JourConteneur('30BC','BC');
    _bc = new JourConteneur('30BC', 'BCcharge');
    readCache();
  }

  void readCache()async{

    String _cacheText;
    _cacheText = await FileUtils.readCacheJour();
    //_cacheText = '';
    if (_cacheText == ''){
      String textInit = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n<uneJourne>\n</uneJourne>';
      FileUtils.writeCacheJour(textInit);
      JourConteneur.initEnregCache(textInit);

    }
    else{
        JourConteneur.enregCache.readCacheXml(_vin);
        JourConteneur.enregCache.readCacheXml(_bc);
        JourConteneur.enregCache.readCacheXml(_teteEtQueue);
        JourConteneur.enregCache.readCacheXml(_edv);
        JourConteneur.enregCache.readCacheXml(_brouillis);
        JourConteneur.enregCache.readCacheXml(_secondes);
        JourConteneur.enregCache.readCacheXml(_trenteBc);
        setState(() {});
    }
  }
  void initEnregistreJourne() async{
    enregistreJourne = new SauvPese(path: await FileUtils.readPeseSauv());
  }

  void enregistrer(){
    String _text;
    Map<int, JourConteneur> _mapEnreg = new Map<int, JourConteneur>();
    _mapEnreg[1] = _vin;
    _mapEnreg[2] = _bc;
    _mapEnreg[4] = _teteEtQueue;
    _mapEnreg[5] = _edv;
    _mapEnreg[6] = _secondes;
    _mapEnreg[7] = _brouillis;
    _mapEnreg[8] = _trenteBc;
    enregistreJourne.enregJour(enregistreJourne.builder, DateFormat('dd/MM/yyy').format(DateTime.now()), _mapEnreg);
    _text = enregistreJourne.sauvegarde.toXmlString(pretty: true, indent: '\t' );
    FileUtils.writePeseSauv(_text);


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
                  //cette Ligne designe la premier partie de tableau Cuve et Vin.
                  Row(
                    children: <Widget>[
                      _vin,
                      _bc,
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
                  // Cette Ligne designe le premier ensemble des pesée de la journée. (T&Q, EDV, Secondes).
                  Row(
                    children: <Widget>[
                      _teteEtQueue,
                      _edv,
                      _brouillis,
                    ],
                  ),
                  // Cette Ligne designe le premier ensemble des pesée de la journée. (T&Q, EDV, Secondes).
                  Row(
                    children: <Widget>[
                      _secondes,
                      _trenteBc,
                    ],
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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