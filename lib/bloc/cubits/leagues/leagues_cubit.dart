import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/models/league.dart';
import 'package:road_to_the_throne/models/player.dart';

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
      for (String playerId in league.playersIds) {
        Player player = await PlayerCubit().getPlayer(playerId);
        await PlayerCubit().updatePlayer(
            {'leaguesPlayed': player.leaguesParticipationCount + 1}, playerId);
      }
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
    Player player = await PlayerCubit().getPlayer(playerId);
    await PlayerCubit()
        .updatePlayer({'wonLeagues': player.wonLeaguesCount + 1}, playerId);
    FlutterToastHelper.showSuccessToast('Winner decided successfully');
    emit(LeaguesInitial());
    getCurrentUserLeagues();
  }
}
