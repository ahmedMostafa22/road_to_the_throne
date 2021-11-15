import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/widgets/league_item.dart';
import 'package:road_to_the_throne/widgets/loading.dart';

class LeaguesTab extends StatelessWidget {
  const LeaguesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaguesCubit, LeaguesState>(
      builder: (context, state) {
        return state is LeaguesLoaded
            ? ListView.builder(
                itemCount: state.leagues.length,
                itemBuilder: (c, i) => LeagueItem(league: state.leagues[i]))
            : const Loading(size: 50);
      },
    );
  }
}
