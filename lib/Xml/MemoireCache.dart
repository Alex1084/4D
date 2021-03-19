import '../metier/ConteneurJour.dart';
import 'package:xml/xml.dart';

// cette classe utilise le meme principe que la classe SauvPese
// a le diference près que cette classe enregistre automatiquement les donne dans la memoire cache
class MemoireCache{

  XmlDocument sauvegarde;
  XmlBuilder builder;
  MemoireCache({String path}){

  sauvegarde = new XmlDocument.parse(path);
  builder = new XmlBuilder();
  }

  void readCacheXml(JourConteneur unContainer) {
    try{
  sauvegarde.findAllElements('uneJourne').forEach((element) {
    element.findAllElements('Pesee').forEach((element) {
      if (element.attributes.single.value == unContainer.getAttributXml()) {
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
      }
    });
  });}
    catch(e){
      print(e);
      unContainer.setVolume('0.00');
      unContainer.setTemperature('0.00');
      unContainer.setDegreM('0.00');
      unContainer.setDegreR('0.00');
      unContainer.setVolumeAp('0.00');
    }
  }





  void enregPese( JourConteneur unContainer){
        sauvegarde.findAllElements('Pesee').forEach((element) {
          if (element.attributes.single.value == unContainer.getAttributXml()) {
            sauvegarde.firstElementChild.children.remove(element);
          }
        });
        this.builder.element('Pesee', nest: () {
          this.builder.attribute('type', '${unContainer.getAttributXml()}');
          this.builder.element('Volume', nest: unContainer.getVolume());
          this.builder.element('Enfoncement', nest: unContainer.getDegreM());
          this.builder.element('Temperature', nest: unContainer.getTemperature());
          this.builder.element('EnfoncementR', nest: unContainer.getDegreR());
          this.builder.element('VolumeAp', nest: unContainer.getVolumeAp());
        });
        this.sauvegarde.firstElementChild.children.add(
            this.builder.buildFragment());
      //findElements('lesPeseJourne').
  //print(builder.element.toString());
  }
}