import 'dart:io';
import 'package:path_provider/path_provider.dart';

//cette Classe est une classe static, elle permet de lire et d'ecrire des fichier qui on pour but d'etre editer cotidiennement par l'utilisateur

//lien de documentation : https://pub.dev/packages/path_provider/install
class FileUtils {
 static int annee = 2020;
 static int anneeproch = annee +1;
  static Future<String> get getExternalPath async {
    //pour trouver le chemin d'un file
    final directory = await getExternalStorageDirectory();
    return directory.path;
    }

  //#region fichier pour sauvegarde les pese
  static Future<File> get getFilePeseSauv async {
    //recherche le file PeseSauv avac les getPathData
    final path = await getExternalPath;
    return File('$path/donne-Campagne-$annee-$anneeproch.xml');
  }

  static Future<String> readPeseSauv() async {
    try {
      final file = await getFilePeseSauv;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "";
    }
  }

  static Future<File> writePeseSauv(String uneLigne) async {
    final file = await getFilePeseSauv;

    // Write the file.
    return file.writeAsString('$uneLigne');
  }
  //#endregion
  //#region memoire cache Ecran Journe
  static Future<File> get getFileCacheJour async {
    //recherche le file PeseSauv avac les getPathData
    final path = await getExternalPath;
    return File('$path/CacheFileJour.xml');
  }

  static Future<String> readCacheJour() async {
    try {
      final file = await getFileCacheJour;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "";
    }
  }

  static Future<File> writeCacheJour(String uneLigne) async {
    final file = await getFileCacheJour;

    // Write the file.
    return file.writeAsString('$uneLigne');
  }
//#endregion

  //#region memoire cache Ecran Nuit
  static Future<File> get getFileCacheNuit async {
    //recherche le file PeseSauv avac les getPathData
    final path = await getExternalPath;
    return File('$path/CacheFileNuit.xml');
  }

  static Future<String> readCacheNuit() async {
    try {
      final file = await getFileCacheNuit;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "";
    }
  }

  static Future<File> writeCacheNuit(String uneLigne) async {
    final file = await getFileCacheNuit;

    // Write the file.
    return file.writeAsString('$uneLigne');
  }
//#endregion
}