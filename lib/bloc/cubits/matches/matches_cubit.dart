import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/player.dart';
import 'package:road_to_the_throne/models/team.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  MatchesCubit() : super(MatchesInitial());

  Future<void> getCurrentUserMatches(List<Team> teams) async {
    try {
      emit(MatchesLoading());
      List<Match> matches =
          await getUserMatches(teams, FirebaseAuth.instance.currentUser!.uid);
      emit(MatchesLoaded(matches));
    } catch (e) {
      print(e);
      emit(MatchesError());
    }
  }

  Future<List<Match>> getUserMatches(List<Team> teams, String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where('firstPlayerId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(25)
        .get();
    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('matches')
        .where('secondPlayerId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(25)
        .get();
    List<Match> matches =
        querySnapshot.docs.map((m) => Match.fromFirestore(m, teams)).toList();
    matches
        .addAll(querySnapshot2.docs.map((m) => Match.fromFirestore(m, teams)));
    matches.sort((a, b) => b.date.compareTo(a.date));
    return matches;
  }

  Future<List<Match>> getVersusMatches(
      List<Team> teams, String firstPlayerId, String secondPlayerId) async {
    late QuerySnapshot querySnapshot, querySnapshot2;
    await Future.wait([
      FirebaseFirestore.instance
          .collection('matches')
          .where('firstPlayerId', isEqualTo: firstPlayerId)
          .where('secondPlayerId', isEqualTo: secondPlayerId)
          .orderBy('date', descending: true)
          .get()
          .then((v) => querySnapshot = v),
      FirebaseFirestore.instance
          .collection('matches')
          .where('firstPlayerId', isEqualTo: secondPlayerId)
          .where('secondPlayerId', isEqualTo: firstPlayerId)
          .orderBy('date', descending: true)
          .get()
          .then((v) => querySnapshot2 = v)
    ]);
    List<Match> matches =
        querySnapshot.docs.map((m) => Match.fromFirestore(m, teams)).toList();
    matches
        .addAll(querySnapshot2.docs.map((m) => Match.fromFirestore(m, teams)));
    matches.sort((a, b) => b.date.compareTo(a.date));

    return matches;
  }

  Future<void> addMatch(Match match, List<Team> teams) async {
    try {
      emit(MatchesLoading());
      await FirebaseFirestore.instance.collection('matches').add(match.toMap());
      Player firstPlayer = await PlayerCubit().getPlayer(match.firstPlayerId);
      Player secondPlayer = await PlayerCubit().getPlayer(match.secondPlayerId);
      await PlayerCubit().updatePlayer({
        'drawMatches': firstPlayer.drawsCount +
            (match.getMatchWinnerId() == 'DRAW' ? 1 : 0),
        'lostMatches': firstPlayer.lossesCount +
            (match.getMatchWinnerId() == secondPlayer.id ? 1 : 0),
        'wonMatches': firstPlayer.winsCount +
            (match.getMatchWinnerId() == firstPlayer.id ? 1 : 0),
        'gamesCount': firstPlayer.gamesCount + 1,
        'goalsConceded': firstPlayer.goalsConceded + match.secondScore,
        'goalsScored': firstPlayer.goalsScored + match.firstScore
      }, firstPlayer.id);
      await PlayerCubit().updatePlayer({
        'drawMatches': secondPlayer.drawsCount +
            (match.getMatchWinnerId() == 'DRAW' ? 1 : 0),
        'lostMatches': secondPlayer.lossesCount +
            (match.getMatchWinnerId() == firstPlayer.id ? 1 : 0),
        'wonMatches': secondPlayer.winsCount +
            (match.getMatchWinnerId() == secondPlayer.id ? 1 : 0),
        'gamesCount': firstPlayer.gamesCount + 1,
        'goalsConceded': secondPlayer.goalsConceded + match.firstScore,
        'goalsScored': secondPlayer.goalsScored + match.secondScore
      }, secondPlayer.id);
      await getCurrentUserMatches(teams);
      FlutterToastHelper.showSuccessToast('Match recorded successfully');
    } catch (e) {
      print(e);
      emit(MatchesError());
    }
  }

  Future<List<Match>> getLeagueMatches(
      String leagueId, List<Team> teams) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('leagueId', isEqualTo: leagueId)
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs
          .map((m) => Match.fromFirestore(m, teams))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteMatch(Match match) async {
    if (FirebaseAuth.instance.currentUser!.email ==
        'ahmed.sasa223344@gmail.com') {
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(match.id)
          .delete();
      Player firstPlayer = await PlayerCubit().getPlayer(match.firstPlayerId);
      Player secondPlayer = await PlayerCubit().getPlayer(match.secondPlayerId);
      await PlayerCubit().updatePlayer({
        'drawMatches': firstPlayer.drawsCount -
            (match.getMatchWinnerId() == 'DRAW' ? 1 : 0),
        'lostMatches': firstPlayer.lossesCount -
            (match.getMatchWinnerId() == secondPlayer.id ? 1 : 0),
        'wonMatches': firstPlayer.winsCount -
            (match.getMatchWinnerId() == firstPlayer.id ? 1 : 0),
        'gamesCount': firstPlayer.gamesCount - 1,
        'goalsConceded': firstPlayer.goalsConceded - match.secondScore,
        'goalsScored': firstPlayer.goalsScored - match.firstScore
      }, firstPlayer.id);
      await PlayerCubit().updatePlayer({
        'drawMatches': secondPlayer.drawsCount -
            (match.getMatchWinnerId() == 'DRAW' ? 1 : 0),
        'lostMatches': secondPlayer.lossesCount -
            (match.getMatchWinnerId() == firstPlayer.id ? 1 : 0),
        'wonMatches': secondPlayer.winsCount -
            (match.getMatchWinnerId() == secondPlayer.id ? 1 : 0),
        'gamesCount': secondPlayer.gamesCount - 1,
        'goalsConceded': secondPlayer.goalsConceded - match.firstScore,
        'goalsScored': secondPlayer.goalsScored - match.secondScore
      }, secondPlayer.id);
    }
  }
}
