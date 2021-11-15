import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/team.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  MatchesCubit() : super(MatchesInitial());

  Future<void> getCurrentUserMatches(List<Team> teams) async {
    try {
      emit(MatchesLoading());
      List<Match> matches = await getUserMatches(
          teams, FirebaseAuth.instance.currentUser!.uid);
      emit(MatchesLoaded(matches));
    } catch (e) {
      print(e);
      emit(MatchesError());
    }
  }

  Future<List<Match>> getUserMatches(
      List<Team> teams, String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('matches')
        .where('firstPlayerId', isEqualTo: uid)
        .get();
    QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('matches')
        .where('secondPlayerId', isEqualTo: uid)
        .get();
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
          .orderBy('date')
          .get();
      return querySnapshot.docs
          .map((m) => Match.fromFirestore(m, teams))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteMatch(String matchId) async {
    await FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .delete();
  }
}
