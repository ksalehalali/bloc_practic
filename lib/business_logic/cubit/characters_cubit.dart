import 'package:bloc/bloc.dart';
import 'package:bloc_practic/data/models/characters.dart';
import 'package:bloc_practic/data/repos/characters_repo.dart';
import 'package:meta/meta.dart';

import '../../data/models/char-quotes.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepo charactersRepo;
  late List<Character> myCharacters = [];
  CharactersCubit(this.charactersRepo) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepo.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.myCharacters = characters;
    });

    return myCharacters;
  }

  void getQuotes(String charName) {
    charactersRepo.getAllCharQuotes(charName).then((quotes) {
       emit(QuotesLoaded(quotes));

    });
  }


}
