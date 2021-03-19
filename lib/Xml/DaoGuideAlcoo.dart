import 'package:xml/xml.dart';
import '../metier/GuideAlcoo.dart';

// cette classe est utiliser pour transformer le fichier appeler (un fichier placer dans assets/data/cahierJaune)
// et transforme une balise <unLigne> en un objet GuideAlcoo
// puis ces objet stocke dans une list
class DocXml {
   XmlDocument _doc;
   List<GuideAlcoo> _listFeuilleB;
   List<String> listElement;
  DocXml(String path){
    _doc  = XmlDocument.parse(path);
    _listFeuilleB = new List<GuideAlcoo>();
    listElement = new List<String>();
  }

   void generationFeuille(){
     double degreM, degreR, temp;
     final titles = _doc.findAllElements('uneLigne');
     titles.forEach((element) {
       temp = double.parse(element.findElements('Temperature').first.text);
       GuideAlcoo uneligne = new GuideAlcoo(temp);

       for(var i = 0; i <= 9; i++){
         final cle = element.findAllElements('Cle$i');
         cle.forEach((element) {
           degreM = double.parse(element.findElements('DegreMesure').first.text);
           degreR = double.parse(element.findElements('DegreRectifier').first.text);
           uneligne.ajoutDegreRec(degreM, degreR);
         });
       }
       _listFeuilleB.add(uneligne);
     });
   }

   List<GuideAlcoo> get listFeuilleB => _listFeuilleB;

   //}
}
