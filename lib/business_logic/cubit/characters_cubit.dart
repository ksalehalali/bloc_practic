import 'package:bloc/bloc.dart';
import 'package:bloc_practic/data/models/characters.dart';
import 'package:bloc_practic/data/repos/characters_repo.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepo charactersRepo;
  late List<Character> myCharacters = [];
  CharactersCubit(this.charactersRepo) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepo.getAllCharacters().then((characters) {
      return emit(CharactersLoaded(characters));
      this.myCharacters = characters;
    });

    return myCharacters;
  }
}
