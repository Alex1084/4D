import 'package:apllication_4d/Xml/DaoGuideAlcoo.dart';
import 'package:flutter/material.dart';

import '../Xml/FileUtils.dart';
import '../ihm/Dialog.dart';
import 'GuideAlcoo.dart';
import '../Xml/MemoireCache.dart';



//cette class est l'objet utiliser pour un conteneur dans les ecran Jour et Nuit
class JourConteneur extends StatefulWidget{
  //chaque conteneur est qualifier par deux titre,
  // un tritre Box utiliser a l'afichage pour la comprehention de l'utilisateur
  // et un attribut celui ci est utiliser dans l'enregistrement du fichier xml afin de pourvoir identifier le type de pese
  String _titreBox, _attributXml, _volumeAp;
  double _volume, _degreM, _temperature, _degreR;
  Color colorConteneur;
  bool marge = false;
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


  JourConteneur(String unTitre,unAttributXml,Color uneCouleur, {Key key, bool uneMarge = false}) : super(key: key){
    this.marge = uneMarge;
    this.colorConteneur = uneCouleur;
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
  DocXml data;

//cette methode est utiliser dans le seul but de mettre a jour l'interface un fois que la saisie d'une pese est valider
  void setStateContainer(){
    setState(() {
    });
  }

  //cette methode va chercher dans la liste de guideAlcoo pour retourner l'enfoncement reel grace a le temperature et l'enfoncement lu
  //la liste unGuide est obtenue grace au getteur se trouvent dans le document DaoGuideAlcoo
  double rechercheDegre(List<GuideAlcoo> unGuide, double unDegreMesure,double uneTemperature) {
    double degreRectifie = 0;
    int degreRangeMesure;
    bool trouver = false;
    bool finis = false;
    degreRangeMesure = unDegreMesure.toInt();
    int i = 0;
    while(trouver == false && finis == false )
    {
      //print(i);
      if(uneTemperature == unGuide[i].getTemperature() && unGuide[i].degreRectifie.containsKey(degreRangeMesure))
      {
        degreRectifie = unGuide[i].degreRectifie[unDegreMesure];
        trouver = true;
      }
      else
      if (i == unGuide.length-1)
      {
        finis = true;
      }
      else {
        i++;
      };
    }
    if (trouver == true){
      return degreRectifie;
    }
    else if(finis = true){
      return -1;
    }
  }

  // cette methode est un controlle de saisie elle creer une exception si les donne saisie par l'utilisateur ne peuvent pas etre converti en double
  // cette methode permet aussi a l'utilisateur d'utiliser la virgule (au lieu du point) pour saisire les chiffre
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
      margin: (widget.marge == false ? EdgeInsets.only(top: MediaQuery.of(context).size.width / 36, left: MediaQuery.of(context).size.width / 18)  :  EdgeInsets.only(top: MediaQuery.of(context).size.width / 36,)),
      decoration: BoxDecoration(
          color: widget.colorConteneur,
        // color:(widget._titreBox.substring(0,3) =='vin' ? Colors.blue[100] : Colors.greenAccent[100]),
        //shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1,),
      ),

      //le widget Inkwell permet de faire une action lorsque l'utilisateur clic dessus celui sir permet d'affiche le pop ip dialogZoom
      child:InkWell(
        onTap: (){
          LesDialog.dialogZoom(context , widget._titreBox ,widget._volume.toString(), widget._degreR.toString(), widget._volumeAp.toString(), widget._temperature.toString(), widget._degreM.toString());
          setState((){});
        },


        child : Column(
          children: <Widget>[
          Text('${widget._titreBox}',
            textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,),
          Text('Enfoncement : ${widget._degreR}',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18
            ),), //Designe le Degré Rectifier
          Text('Volume AP : ${widget._volumeAp}',
            textDirection: TextDirection.ltr,
            style: TextStyle( //Designe le Volume D'alcool Pur
                fontSize: 18
            ),
              textAlign: TextAlign.center,
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
              child: IconButton(icon: Icon(Icons.add_circle,), // ce bouton permet d'afficher le pop up qui permet a l'utilisateur de saisir les donnees d'une pesee
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
    double verif;
    String assetPath;
    bool verifTemp, verifDegre, verifVolume;

    // ce if permet de remplir les TextField si il ont deja ete remplis
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
                          keyboardType: TextInputType.number,
                          controller: volumeDialog,
                          onChanged: (String text) {
                            //chaque textField verifie en temps reel si la saisie est corect sinon le errortext s'affiche pour le signaler a l'utilisateur
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
                            //chaque textField verifie en temps reel si la saisie est corect sinon le errortext s'affiche pour le signaler a l'utilisateur
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
                            enabled: (unTitre.toLowerCase() == 'vin' ? false : true), //pour les conteneur de vin la temperature n'est pas nessessaire alors le textField est desactiver si le titre est egal a "vin"
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
                            //chaque textField verifie en temps reel si la saisie est corect sinon le errortext s'affiche pour le signaler a l'utilisateur
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
                            //verifie si l'enfoncement saisie existe de les fichier si il n'existe pas un message d'erreur s'affiche
                            try {
                              assetPath = await DefaultAssetBundle.of(context).loadString(recherchedocument(widget._degreM));
                              data = new DocXml(assetPath);
                              data.generationFeuille();
                              //recherche le l'enfoncement reel de pour ensuite calculer le volume d'alcool pur
                                widget._degreR = rechercheDegre(this.data.listFeuilleB, widget._degreM, widget._temperature);
                                widget._volumeAp =
                                    (widget._volume * widget._degreR / 100).toStringAsFixed(4);
                                JourConteneur.enregCache.enregPese(widget);

                                //enregistre dans les deux fichier de memoire cache les donne de la pesee
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
                              //si le conteneur est du vin la recherche de l'enfoncement reel n'est pas nessessaire alors l'enfoncement mesure est egal a l'enfoncement reel
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


  //recherche le fichier ou se trouve les veleur demander,
  //si la valeur n'est pas trouver alors la fonction renvoie un exception
  //les fichier on ete separer en trois dossier afin de faciliter les recherche
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


