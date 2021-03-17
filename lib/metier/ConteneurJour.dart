import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tab4dv2/Xml/DaoGuideAlcoo.dart';
import '../Xml/FileUtils.dart';
import '../ihm/Dialog.dart';
import 'GuideAlcoo.dart';
import '../Xml/MemoireCache.dart';
class JourConteneur extends StatefulWidget{
  String _titreBox, _attributXml, _volumeAp;
  double _volume, _degreM, _temperature, _degreR;
  static MemoireCache enregCache;

  static initEnregCache(String path) async{
    enregCache = new MemoireCache(path: path);
  }
  //#region les Getteur
  String getTitreBox(){
    return this._titreBox;
  }
  double getVolume(){
    return this._volume;
  }
  double getDegreM(){
    return this._degreM;
  }
  double getTemperature(){
    return this._temperature;
  }
  double getDegreR(){
    return this._degreR;
  }
  String getVolumeAp(){
    return this._volumeAp;
  }
  String getAttributXml(){
    return _attributXml;
  }
  //#endregion
  //#region les Setteur
  void setVolume(String value){
    this._volume = double.parse(value);
  }
  void setDegreM(String value){
    this._degreM = double.parse(value);
  }
  void setTemperature(String value){
    this._temperature = double.parse(value);
  }

  void setDegreR(String value){
    this._degreR = double.parse(value);
  }

  void setVolumeAp(String value){
    this._volumeAp = value;
  }
//#endregion

  @override
  String retourString(){
    return '$_titreBox , $_volume, $_degreM, $_temperature, $_degreR, $_volumeAp';
  }

  JourConteneur(String unTitre,unAttributXml, {Key key}) : super(key: key){
    this._titreBox = unTitre;
    this._attributXml = unAttributXml;
    this._volume = 0.00;
    this._degreM = 0.00;
    this._temperature = 0.00;
    this._volumeAp = '0.00';
    this._degreR = 0.00;
  }

  @override
  _JourConteneur createState() => new _JourConteneur();

}

class _JourConteneur extends State<JourConteneur> {
  @override
  initState(){
    setState(() {

    });
  }
  DocXml data;

  void setStateContainer(){
    setState(() {

    });
  }

  double rechercheDegre(List<GuideAlcoo> unGuide, double unDegreMesure,double uneTemperature) {
    double degreRectifie = 0;
    int degreRangeMesure;
    degreRangeMesure = unDegreMesure.toInt();
    GuideAlcoo unGuideAlcoo = new GuideAlcoo(0);
    unGuide.forEach((GuideAlcoo unGuideAlcoo) {
      if (uneTemperature == unGuideAlcoo.getTemperature() && unGuideAlcoo.degreRectifie.containsKey(degreRangeMesure))
        unGuideAlcoo.degreRectifie.forEach((key, value) {
          if (unDegreMesure == key) {
            degreRectifie = value;
          }
        });
    });
    return degreRectifie;
  }

  double controlSai(String uneMesure){
    String mesureRetourner;
    if(double.tryParse(uneMesure) == null) {
      int virgule = uneMesure.indexOf(',');
      if (virgule != -1) {
        String uniter = uneMesure.substring(0, virgule);
        String dixieme = uneMesure.substring(virgule + 1, uneMesure.length);
        mesureRetourner = '$uniter.$dixieme';
      }
      else {
        //snack;
        mesureRetourner= '#';
      }
    }
    else{
      mesureRetourner = uneMesure;
    }
    return double.parse(mesureRetourner);

  }

  Widget build(BuildContext context) {

    return Container(
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
        // color:(widget._titreBox.substring(0,3) =='vin' ? Colors.blue[100] : Colors.greenAccent[100]),
        //shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1,),
      ),

      child:InkWell(
        onTap: (){
          LesDialog.dialogZoom(context , widget._titreBox ,widget._volume.toString(), widget._degreR.toString(), widget._volumeAp.toString(), widget._temperature.toString(), widget._degreM.toString());
          setState((){});
        },


        child : Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          Text('${widget._titreBox}',
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),), //Titre du Container.
          Text('Volume :  ${widget._volume}',
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 18
            ),
            textAlign: TextAlign.left,),
          Text('Degre : ${widget._degreR}',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 18
            ),), //Designe le Degré Rectifier
          Text('Volume AP : ${widget._volumeAp}',
            textDirection: TextDirection.ltr,
            style: TextStyle( //Designe le Volume D'alcool Pur
                fontSize: 18
            ),
              textAlign: TextAlign.left,
          ),
          Flexible(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              width: MediaQuery
                .of(context)
                .size
                .width / 5.5,
              decoration: BoxDecoration(
                //color:(widget._attributXml.substring(0,3) =='vin' ? Colors.blue[100] : Colors.greenAccent[200]),
                border: Border.all(color: Colors.black, width: 1,),
              ),
              child: IconButton(icon: Icon(Icons.add_circle,),
                color: Colors.black,
                iconSize : 33,
                onPressed: (){

                  dialogDistilation(context, widget._titreBox);
                }),
            ),
          ),

        ],
        ),
      ),
    );
  }

  Future<Null> dialogDistilation(BuildContext context, String unTitre)  async{
    TextEditingController volumeDialog = new TextEditingController();
    TextEditingController temperatureDialog = new TextEditingController();
    TextEditingController  degreDialog = new TextEditingController();
    String textErreur = '';
    double verif = 0.00;
    String assetPath;
    bool verifTemp, verifDegre, verifVolume;
    if(widget._volume != 0.00) {
      volumeDialog.text = widget._volume.toString();
      temperatureDialog.text = widget._temperature.toString();
      degreDialog.text = widget._degreM.toString();

    }
    else{
      volumeDialog.text = '';
      temperatureDialog.text = '';
      degreDialog.text = '';
    }

    showDialog(
        context: context,
        builder: (context){
      return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Text('Pesée $unTitre'),
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width /4,
                        height: MediaQuery.of(context).size.height / 11,
                        margin: EdgeInsets.only(left: 50),
                        child: TextField(
                          //expands: true,
                          keyboardType: TextInputType.number,
                          controller: volumeDialog,
                          onChanged: (String text) {
                            try {

                                verif = controlSai(volumeDialog.text);
                                verifVolume = false;

                            }
                            catch (e) {
                              verifVolume = true;
                            }
                            setState((){});
                          },
                          style: TextStyle(fontSize: 32),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Volume',
                            labelStyle: TextStyle(fontSize: 32),
                            errorText: (verifVolume == true
                                ? 'erreur de saisie'
                                : null),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /4,
                        height: MediaQuery.of(context).size.height / 11,
                        margin: EdgeInsets.only(left: 50),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: temperatureDialog,
                          onChanged: (String text) {
                             try{
                              controlSai(temperatureDialog.text);
                              verifTemp = false;
                            }
                            catch(e){
                            verifTemp = true;
                            }
                             setState((){});
                          },
                          style: TextStyle(fontSize: 32),
                          decoration: InputDecoration(
                            errorText: (verifTemp == true ? 'erreur de saisie' : null),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Temperature',
                            labelStyle: TextStyle(fontSize: 32),
                            enabled: (unTitre.toLowerCase() == 'vin'
                                ? false
                                : true),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /4,
                        height: MediaQuery.of(context).size.height / 11,
                        margin: EdgeInsets.only(left: 50),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: degreDialog,
                          onChanged: (String text) {
                            try {

                                controlSai(degreDialog.text);
                                verifDegre = false;
                                textErreur = '';

                            }
                            catch (e) {
                              verifDegre = true;
                            }
                            setState((){});
                          },
                          style: TextStyle(fontSize: 32),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enfoncement',
                            labelStyle: TextStyle(fontSize: 32),
                            errorText: (verifDegre == true
                                ? 'erreur de saisie'
                                : null),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                Row(
                  children: [
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width /4,
                      margin: EdgeInsets.only(left: 100, top: 25),
                      child: RaisedButton(
                        onPressed: () async {
                          widget._degreM = controlSai(degreDialog.text);

                          widget._volume = controlSai(volumeDialog.text);

                          if (unTitre.toLowerCase() != 'vin') {
                            widget._temperature = controlSai(temperatureDialog.text);
                            try {
                              assetPath = await DefaultAssetBundle.of(context).loadString(recherchedocument(widget._degreM));
                              data = new DocXml(assetPath);
                              data.generationFeuille();
                                widget._degreR = rechercheDegre(this.data.listFeuilleB, widget._degreM, widget._temperature);
                                widget._volumeAp =
                                    (widget._volume * widget._degreR / 100).toStringAsFixed(4);
                                JourConteneur.enregCache.enregPese(widget);
                                FileUtils.writeCacheJour(
                                    JourConteneur.enregCache.sauvegarde
                                        .toXmlString(pretty : true, indent: '\t'));
                                FileUtils.writeCacheNuit(
                                    JourConteneur.enregCache.sauvegarde
                                        .toXmlString(pretty : true, indent: '\t'));
                              Navigator.of(context).pop();
                            }
                            catch (e) {
                              setState(() {
                                textErreur = 'une erreur c\'est produite l\'enfoncement demander n\'a pas été trouver';
                              });
                            }
                          }
                          else {

                              widget._temperature = 0.00;
                              widget._degreR = widget._degreM;
                              widget._volumeAp = (widget._volume * widget._degreM / 100).toStringAsFixed(4);
                              JourConteneur.enregCache.enregPese(widget);
                              FileUtils.writeCacheJour(
                                  JourConteneur.enregCache.sauvegarde
                                      .toXmlString(pretty : true, indent: '\t'));
                              FileUtils.writeCacheNuit(
                                  JourConteneur.enregCache.sauvegarde
                                      .toXmlString(pretty : true, indent: '\t'));


                            Navigator.of(context).pop();
                          }
                          setStateContainer();
                        },
                        child: Text('Valider',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width /4,
                      margin: EdgeInsets.only(left: 100, top: 25),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Annuler',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ],
                ),
                Text('$textErreur',

                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                  ),
                ),
              ],
            );
          }
      );
  }
    );

  }

  String recherchedocument(double degre){
    String path;
    //ce if va rechercher dans le dossier 1027
    if(degre < 28){
      if(degre < 10 || degre >= 23 && degre < 26 ){
        path = null;
      }
      else if(degre >=10 && degre < 13){
        path = 'assets/data/cahierJaune/1027/1012.xml';
      }
      else if(degre >=13 && degre < 16){
        path = 'assets/data/cahierJaune/1027/1315.xml';
      }
      else if(degre >= 16 && degre <19){
        path = 'assets/data/cahierJaune/1027/1618.xml';
      }
      else if(degre >= 19 && degre <22){
        path = 'assets/data/cahierJaune/1027/1921.xml';
      }
      else if(degre >= 22 && degre <23 || degre >= 26 && degre < 28){
        path = 'assets/data/cahierJaune/1027/222627.xml';
      }

    }
    //ce esle if va rechercher dans le dossier 3039
    else if(degre >= 28 && degre < 40) {
      if (degre >= 28 && degre < 31) {
        path = 'assets/data/cahierJaune/3039/2830.xml';
      }
      else if (degre >= 31 && degre < 34) {
        path = 'assets/data/cahierJaune/3039/3133.xml';
      }
      else if (degre >= 34 && degre < 37) {
        path = 'assets/data/cahierJaune/3039/3436.xml';
      }
      else if (degre >= 37 && degre < 40) {
        path = 'assets/data/cahierJaune/3039/3739.xml';
      }
    }
    //ce esle if va rechercher dans le dossier 4072
    else if(degre >= 40 && degre <= 72){
      //aucun fichier n'a de valeur pour un degre compris entre 43 et 66 et superieure a 72.9
      if(degre >= 43 && degre <66 || degre > 72.9 ){
        path = null;
      }
      else if(degre >=40 && degre < 43){
        path = 'assets/data/cahierJaune/4072/4042.xml';
      }
      else if(degre >=66 && degre < 69){
        path = 'assets/data/cahierJaune/4072/6668.xml';
      }
      else if(degre >= 69 && degre <73){
        path = 'assets/data/cahierJaune/4072/6872.xml';
      }
    }

    return path;
  }


}