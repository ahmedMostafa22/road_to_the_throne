import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:road_to_the_throne/models/league.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/player.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(PlayerInitial());

  Future<void> getCurrentPlayer(
      List<Match> matches, List<League> leagues) async {
    try {
      emit(PlayerLoading());
      Player player = await getPlayer(
          matches, leagues, FirebaseAuth.instance.currentUser!.uid);
      emit(PlayerLoaded(player));
    } catch (e) {
      print(e);
    }
  }

  Future<Player> getPlayer(
      List<Match> matches, List<League> leagues, String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    int wonMatches = 0,
        lostMatches = 0,
        drawMatches = 0,
        goalsScored = 0,
        goalsConceded = 0;

    for (int i = 0; i < matches.length; i++) {
      if (matches[i].firstScore == matches[i].secondScore) {
        drawMatches++;
      } else if (matches[i].winnerPlayerId == uid) {
        wonMatches++;
      } else {
        lostMatches++;
      }

      if (matches[i].firstPlayerId == uid) {
        goalsScored += matches[i].firstScore;
      } else {
        goalsConceded += matches[i].firstScore;
      }
      if (matches[i].secondPlayerId == uid) {
        goalsScored += matches[i].secondScore;
      } else {
        goalsConceded += matches[i].secondScore;
      }
    }
    return Player(
        uid,
        doc.get('name'),
        doc.get('image'),
        leagues.where((l) => l.winnerPlayerId == uid).toList().length,
        matches.length,
        wonMatches,
        lostMatches,
        drawMatches,
        goalsScored,
        goalsConceded,
        leagues.where((l) => l.playersIds.contains(uid)).toList().length);
  }
}
