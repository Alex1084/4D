import 'package:xml/xml.dart';
import '../metier/GuideAlcoo.dart';


class DocXml {
  //List<GuideAlcoo> feuilleB = new List();
   XmlDocument _doc;
   List<GuideAlcoo> _listFeuilleB;
   List<String> listElement;
  DocXml(String path){
    _doc  = XmlDocument.parse(path);
    _listFeuilleB = new List<GuideAlcoo>();
    listElement = new List<String>();
  }

   void generationFeuille(){
     double degMes, degRect, temp;
     final titles = _doc.findAllElements('uneLigne');
     titles.forEach((element) {
       temp = double.parse(element.findElements('Temperature').first.text);
       GuideAlcoo uneligne = new GuideAlcoo(temp);

       for(var i = 0; i <= 9; i++){
         final cle = element.findAllElements('Cle$i');
         cle.forEach((element) {
           degMes = double.parse(element.findElements('DegreMesure').first.text);
           degRect = double.parse(element.findElements('DegreRectifier').first.text);
           uneligne.ajoutDegreRec(degMes, degRect);
         });
       }
       _listFeuilleB.add(uneligne);
     });
   }

   List<GuideAlcoo> get listFeuilleB => _listFeuilleB;

//XmlDocument get doc => _doc;
   //}
}
