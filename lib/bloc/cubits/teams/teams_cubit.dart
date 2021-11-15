import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:provider/src/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/image_picker/image_picker_cubit.dart';
import 'package:road_to_the_throne/helpers/firebase_storage.dart';
import 'package:road_to_the_throne/models/team.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit() : super(TeamsInitial());

  Future<void> getTeams() async {
    try {
      if ((state is TeamsInitial) == false) return;
      emit(TeamsLoading());
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('teams').get();
      List<Team> teams =
          querySnapshot.docs.map((t) => Team.fromFirestore(t)).toList();
      teams.removeWhere((t) => t.name == 'NA');
      emit(TeamsLoaded(teams));
    } catch (e) {
      print(e);
      emit(TeamsError());
    }
  }

  Future<void> addTeam(Team team, BuildContext context) async {
    try {
      emit(TeamsLoading());
      String imageUrl = await FirebaseStorageHelper.uploadFile(
          context.read<ImagePickerCubit>().state.image, 'Teams');
      await FirebaseFirestore.instance
          .collection('teams')
          .add({'image': imageUrl, 'name': team.name});
      emit(TeamsInitial());
      await getTeams();
    } catch (e) {
      print(e);
      emit(TeamsError());
    }
  }
}
