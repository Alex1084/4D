import 'package:tab4dv2/metier/ConteneurVeille.dart';
import '../metier/ConteneurJour.dart';
import 'package:xml/xml.dart';

class SauvPese{
  XmlDocument sauvegarde;
  XmlBuilder builder;
  SauvPese({String path}){

    sauvegarde = new XmlDocument.parse(path);
    builder = new XmlBuilder();
  }

  void testread(String date, ConteneurVeille unContainer) {
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