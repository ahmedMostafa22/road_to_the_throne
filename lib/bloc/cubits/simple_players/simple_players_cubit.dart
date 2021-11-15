import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:road_to_the_throne/models/simple_player.dart';

part 'simple_players_state.dart';

class SimplePlayersCubit extends Cubit<SimplePlayersState> {
  SimplePlayersCubit() : super(SimplePlayersInitial());

  Future<void> getSimplePlayers() async {
    try {
      if ((state is SimplePlayersInitial) == false) return;
      emit(SimplePlayersLoading());
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<SimplePlayer> players =
          querySnapshot.docs.map((p) => SimplePlayer.fromFirestore(p)).toList();
      emit(SimplePlayersLoaded(players));
    } catch (e) {
      print(e);
      emit(SimplePlayersError());
    }
  }
}
