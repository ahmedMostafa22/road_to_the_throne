import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/models/league.dart';

part 'leagues_state.dart';

class LeaguesCubit extends Cubit<LeaguesState> {
  LeaguesCubit() : super(LeaguesInitial());

  Future<void> addLeague(League league) async {
    try {
      emit(LeaguesLoading());
      await FirebaseFirestore.instance.collection('leagues').add({
        'winnerPlayerId': league.winnerPlayerId,
        'date': league.date.toIso8601String(),
        'playersIds': league.playersIds,
        'name': league.name
      });
      emit(LeaguesInitial());
      getCurrentUserLeagues();
      FlutterToastHelper.showSuccessToast('League added successfully');
    } catch (e) {
      print(e);
      emit(LeaguesError());
    }
  }

  Future<void> getCurrentUserLeagues() async {
    if ((state is LeaguesInitial) == false) return;
    emit(LeaguesLoading());
    List<League> leagues = await getLeagues();
    emit(LeaguesLoaded(leagues));
  }

  Future<List<League>> getLeagues() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('leagues')
          .orderBy('date', descending: true)
          .get();
      return querySnapshot.docs.map((l) => League.fromFirebase(l)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> setLeagueWinner(String leagueId, String playerId) async {
    await FirebaseFirestore.instance
        .collection('leagues')
        .doc(leagueId)
        .update({'winnerPlayerId': playerId});

    FlutterToastHelper.showSuccessToast('Winner decided successfully');
    emit(LeaguesInitial());
    getCurrentUserLeagues();
  }
}
