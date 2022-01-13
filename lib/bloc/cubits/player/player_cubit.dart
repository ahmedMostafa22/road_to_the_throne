import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:road_to_the_throne/models/player.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit() : super(PlayerInitial());

  Future<void> getCurrentPlayer() async {
    try {
      emit(PlayerLoading());
      Player player = await getPlayer(FirebaseAuth.instance.currentUser!.uid);
      emit(PlayerLoaded(player));
    } catch (e) {
      print(e);
    }
  }

  Future<Player> getPlayer(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return Player(
        uid,
        doc.get('name'),
        doc.get('image'),
        doc.get('wonLeagues'),
        doc.get('gamesCount'),
        doc.get('wonMatches'),
        doc.get('lostMatches'),
        doc.get('drawMatches'),
        doc.get('goalsScored'),
        doc.get('goalsConceded'),
        doc.get('leaguesPlayed'),
        doc.get('favTeam'));
  }

  Future<void> updatePlayer(Map<String, Object?> newData,String playerId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(playerId)
        .update(newData);
    await getCurrentPlayer();
  }
}
