class GuideAlcoo{
  double temperature;
  //ces deux variable ci dessus sont la premiere l'adresse du dreger rectifier recherche
  Map<double,double> degreRectifie;  //cette Map contient en les degre Mesure et en valeur les degre rectifier compris dans la range

  GuideAlcoo(double unetemperature){
    this.temperature = unetemperature;
    degreRectifie = new Map<double, double>();
  }

  void ajoutDegreRec(double unDegreMesure, double unDegreRectifier){
    this.degreRectifie[unDegreMesure] = unDegreRectifier;
  }

  double getTemperature(){
    return this.temperature;
  }

  String allDegreString(){
      String allValues = '';
      this.degreRectifie.forEach((key, value) {
        allValues = ('$allValues + $key + $value \n');
      });
      return allValues ;
    }

  void setTemperature(uneTemperature){
    this.temperature;
  }

}