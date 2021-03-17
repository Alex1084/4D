import 'package:tab4dv2/metier/ConteneurVeille.dart';
import '../metier/ConteneurJour.dart';
import 'package:xml/xml.dart';

class SauvPese{
  XmlDocument sauvegarde;
  XmlBuilder builder;
  SauvPese({String path}){

    sauvegarde = new XmlDocument.parse(path); //le document Xml sauvegarde reçois le text du fichier sauvegarder sur l'appereil
    builder = new XmlBuilder();
  }

  //cette methode recherche dans tout le document la pese ayant le type demander et la date damande
  //si les donnee sont trouver alors le conteneur place en parametre reçois les valeur trouver
  //sinon il les valeur sont mise a zero
  void setRead(String date, ConteneurVeille unContainer) {
    bool trouver = false;
     sauvegarde.findAllElements('uneJourne').forEach((element) {
      //element.attributes.first.text;
      if (element.findElements('date').single.text == date) {

        element.findAllElements('Pesee').forEach((element) {
          if (element.attributes.single.value == unContainer.getTitreXml()) {
            unContainer.setVolume(element
                .findElements('Volume')
                .single
                .text);
            unContainer.setTemperature(element
                .findElements('Temperature')
                .single
                .text);
            unContainer.setDegreM(element
                .findElements('Enfoncement')
                .single
                .text);
            unContainer.setDegreR(element
                .findElements('EnfoncementR')
                .single
                .text);
            unContainer.setVolumeAp(element
                .findElements('VolumeAp')
                .single
                .text);
            trouver = true;
          }

        });
      }
    });
     if(trouver == false){
        unContainer.setVolume('0.00');
        unContainer.setTemperature('0.00');
        unContainer.setDegreM('0.00');
        unContainer.setDegreR('0.00');
        unContainer.setVolumeAp('0.00');
     }



  }
  void clear(){
    this.sauvegarde.children.clear();
  }

  //cette methode enregistre toutes les pese contenue dans la map avec l'appel de la methode enregPese
  //les builder ce place dans une balise unejourne si un balise qui contient la balise du jour existe,
  //sinon un balise unejourne est creer avec la date du jour
  enregJour(XmlBuilder builder, String unDate, Map<int,JourConteneur> lesData){
   //print(sauvegarde.toXmlString());
    bool trouver = false;

     sauvegarde.findAllElements('uneJourne').forEach((element) {
        if(element.getElement('date').text == unDate){
          lesData.forEach((key, value) {
            enregPese(builder, value);
            element.firstElementChild.parent.children.add(builder.buildFragment());
          });
          trouver = true;
        }
    });
     if (trouver == false){

       builder.element('uneJourne', nest: (){
         builder.element('date', nest: unDate);
         lesData.forEach((key, value) {
           enregPese(builder, value);
         });
       });
       sauvegarde.firstElementChild.children.add(builder.buildFragment());
     }
    //
  }


  //cette methode enregistre une pesee d'un conteneur se conteneur est ensuite identifier par son atribut pour pouvoir connaitre le type de pese
  void enregPese(XmlBuilder builder, JourConteneur unContainer){
    builder.element('Pesee', nest: () {
      builder.attribute('type', '${unContainer.getAttributXml()}');
      builder.element('Volume', nest: unContainer.getVolume() );
      builder.element('Enfoncement', nest: unContainer.getDegreM() );
      builder.element('Temperature', nest: unContainer.getTemperature() );
      builder.element('EnfoncementR', nest: unContainer.getDegreR() );
      builder.element('VolumeAp', nest: unContainer.getVolumeAp() );
    });
    //print(builder.element.toString());
  }
}