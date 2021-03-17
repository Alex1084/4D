import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../ihm/Dialog.dart';

class ConteneurVeille{
  String _titreBox, _titreXml, _volume, _degreM, _temperature, _volumeAp, _degreR;

  ConteneurVeille(String unTitreBox, String unAttributXml){
    this._titreBox= unTitreBox;
    this._titreXml = unAttributXml;
  }
//#region les setteurs.
  void setVolume(String value) {
    _volume = value;
  }
  void setDegreM(String value) {
    _degreM = value;
  }
  void setTemperature(String value) {
    _temperature = value;
  }
  void setVolumeAp(String value) {
    _volumeAp = value;
  }
  void setDegreR(String value) {
    _degreR = value;
  }

  //endregion
  //#region les getteurs.
  String getTitreXml() {
    return _titreXml;
  }
  double getVolume(){
    return double.parse(_volume);
  }
  double getVolumeAp(){
    return double.parse(_volumeAp);
  }
  //#endregion
  buildContainer(BuildContext context) {

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
        //shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1,),
      ),

      child:InkWell(
        onTap: (){
          if(this._titreBox == 'Brouillis'){
           // LesDialog.dialogZoomBrouillis(context);
          }
          else if(this._titreBox == 'Cuvier'){
            //LesDialog.dialogZoomCuvier(context);
          }
          else {
            LesDialog.dialogZoom(
                context,
                this._titreBox,
                this._volume,
                this._degreR,
                this._volumeAp,
                this._temperature,
                this._degreM);
          }
          },


        child : Column(
          children: <Widget>[
          Text('$_titreBox \n ',
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),), //Titre du Container.
          Text('Volume :  $_volume', textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 18
            ),), //Designe le Volume Mersure
          Text('Degre : $_degreR', textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: 18
            ),), //Designe le Degré Rectifier
          Text('Volume AP : $_volumeAp', textDirection: TextDirection.ltr,
            style: TextStyle( //Designe le Volume D'alcool Pur
                fontSize: 18
            ),),
        ],
        ),
      ),
    );
  }
}