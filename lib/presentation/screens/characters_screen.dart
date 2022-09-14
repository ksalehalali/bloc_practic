import 'package:bloc_practic/business_logic/cubit/characters_cubit.dart';
import 'package:bloc_practic/constants/my_colors.dart';
import 'package:bloc_practic/presentation/widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/characters.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchField() {
    return TextField(
      controller: _searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
          hintText: 'Find a character....',
          border: InputBorder.none,
          hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18)),
      onChanged: (val) {
        addSearchedForItemToSearchedList(val);
      },
    );
  }

  void addSearchedForItemToSearchedList(String text) {
    searchedForCharacters = allCharacters
        .where((element) => element.name.toLowerCase().startsWith(text))
        .toList();
    setState(() {

    });
  }

  List<Widget> _buildAppBarActions(){
    if(_isSearching){
      return [
        IconButton(
            onPressed: (){
              _clearSearch();
              Navigator.pop(context);
            },
            icon:Icon(Icons.close,color: MyColors.myGrey,
            ),
        ),
      ];
    }else{
      return [
        IconButton(
          onPressed: _startSearch,
          icon:Icon(Icons.search,color: MyColors.myGrey,
          ),
        ),
      ];
    }
  }

  void _startSearch (){
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching =true;
    });
  }

  void _stopSearching(){
    _clearSearch();

    setState(() {
      _isSearching=false;
    });
  }

  void _clearSearch(){
    setState(() {
      _searchTextController.clear();
    });
  }
  buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = (state.characters);
        return buildLoadedListWidget();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount:_searchTextController.text.isEmpty? allCharacters.length:searchedForCharacters.length,
      itemBuilder: (ctx, index) => CharacterItem(
        character:_searchTextController.text.isEmpty ? allCharacters[index]:searchedForCharacters[index],
      ),
    );
  }

  Widget showLoadingIndicator() {
    return Center(
        child: CircularProgressIndicator.adaptive(
      backgroundColor: MyColors.myYellow,
    ));
  }

  Widget _buildAppBarTitles() {
    return  Text(
      'Characters',
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching?BackButton(color: MyColors.myGrey):Container(),

        backgroundColor: MyColors.myYellow,
        centerTitle: true,
        title: _isSearching?_buildSearchField():_buildAppBarTitles(),
        actions: _buildAppBarActions(),
      ),
      body: buildBlocWidget(),
    );
  }
}
