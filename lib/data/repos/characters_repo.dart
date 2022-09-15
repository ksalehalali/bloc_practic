import 'package:bloc_practic/data/models/characters.dart';
import 'package:bloc_practic/data/web_services/characters_web_services.dart';
import 'package:dio/dio.dart';

import '../models/char-quotes.dart';

class CharactersRepo {
  final CharactersWebServices charactersWebServices;

  CharactersRepo(this.charactersWebServices);
  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters.map((e) => Character.fromJson(e)).toList();
  }

  Future<List<Quote>> getAllCharQuotes(String charName) async {
    final qoutes = await charactersWebServices.getAllQuotes(charName);
    return qoutes.map((e) => Quote.fromJson(e)).toList();
  }


}
