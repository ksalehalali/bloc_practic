import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloc_practic/business_logic/cubit/characters_cubit.dart';
import 'package:bloc_practic/business_logic/cubit/characters_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/characters_cubit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/characters.dart';

class CaracterDetailsScreen extends StatelessWidget {
  final Character character;

  const CaracterDetailsScreen({Key? key, required this.character})
      : super(key: key);

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(character.nickName,
          style: TextStyle(
            color: MyColors.myWhite,
          ),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
          children: [
            TextSpan(
                text: title,
                style: TextStyle(
                    color: MyColors.myWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )
            ),

            TextSpan(
                text: value,
                style: TextStyle(
                    color: MyColors.myWhite,
                    fontWeight: FontWeight.normal,
                    fontSize: 16
                )
            ),
          ]
      ),

    );
  }

  Widget _buildDivider(double endIndent) {
    return Divider(color: MyColors.myYellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,);
  }

  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgress();
    }
  }

Widget displayRandomQuoteOrEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: MyColors.myWhite, shadows:
          [Shadow(
              blurRadius: 7,
              color: MyColors.myYellow,
              offset: Offset(0, 0)
          )
          ]
          ),
          child:AnimatedTextKit(
              repeatForever: true,
              animatedTexts:[
                FlickerAnimatedText(quotes[randomQuoteIndex].quote),
              ] ),),
      );
    }else{
      return Container();
    }
  }

  Widget showProgress(){
    return Center(child:CircularProgressIndicator.adaptive());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);

    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: Container(
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(),
              SliverList(delegate: SliverChildListDelegate(
                  [
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 14, 14, 0.0),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _characterInfo('Jop : ', character.jobs.join(' / ')),
                          _buildDivider(315),

                          _characterInfo(
                              'Appeared in : ', character.categoryForTwoSeries),
                          _buildDivider(250),

                          _characterInfo('Seasons : ',
                              character.appearanceOfSeasons.join(' / ')),
                          _buildDivider(280),

                          _characterInfo(
                              'Status : ', character.statusIfDeadOrAlive),
                          _buildDivider(300),

                          character.betterCallSaulAppearance.isEmpty
                              ? Container()
                              :
                          _characterInfo('Better Call Saul Seasons : ',
                              character.betterCallSaulAppearance.join(' / ')),
                          character.betterCallSaulAppearance.isEmpty
                              ? Container()
                              :
                          _buildDivider(150),

                          _characterInfo(
                              'Actor/Actress : ', character.acotrName),
                          _buildDivider(235),

                          _characterInfo(
                              'Status : ', character.statusIfDeadOrAlive),
                          _buildDivider(300),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    BlocBuilder<CharactersCubit, CharactersState>(
                      builder: (context, state) {
                        return checkIfQuotesAreLoaded(state);
                      },),
                    SizedBox(height: 110),

                  ]
              ))
            ],
          )),
    );
  }
}
