import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/city.dart';

class CityDatabase {
  static final CityDatabase instance = CityDatabase._init();

  static Database? _database;

  CityDatabase._init();

  Future<Database> get database async { /* Dans cette fonction (Future très similaire à une fonction) on récupère toutes les données de la DB  */
    if (_database != null) return _database!;

    _database = await _initDB('City.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async { /* On initialise une DB à partir du fichier où sont stockées les données de la DB */
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async { /* On créé dans cette DB des table 'TableCity' où sont stockés l'ID et le nom de la ville  */
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $TableCity(
      ${CityFields.Id_city} $idType,
      ${CityFields.Libelle} $textType
    )
    ''');
  }

  Future<String> CreateCity(libelle) async { /* Permet à l'aide du libellé renseigné dans l'input d'ajouter une ville à la liste  */
    final db = await instance.database;
    final city = City(Libelle: libelle);
    String val = await db.insert(TableCity, city.toJson()).toString();
    return val;
  }

  Future<List<City>> FetchAllCity() async { /* Récupérez toutes les villes et leurs données */
    var db = await instance.database;

    const orderBy = '${CityFields.Libelle} ASC';

    final result = await db.query(TableCity, orderBy: orderBy);

    return result.map((json) => City.fromJson(json)).toList();
  }

  Future<int> DeleteCity(int Id_city) async { /* Suppression d'une ville */
    var db = await instance.database;
    return db.delete(
      TableCity,
      where: '${CityFields.Id_city} = ?',
      whereArgs: [Id_city],
    );
  }

  Future close() async { /* Fermer la DB ( et non la shutdown ) */
    final db = await instance.database;
    db.close();
  }
}
