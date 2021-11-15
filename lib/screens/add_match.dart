import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_drop_down_menu.dart';
import 'package:road_to_the_throne/widgets/loading.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({Key? key, this.leagueId = 'NA'}) : super(key: key);
  final String leagueId;

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  int firstTeamScore = 0,
      secondTeamScore = 0,
      firstTeamIndex = 0,
      secondTeamIndex = 0,
      firstPlayerIndex = 0,
      secondPlayerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                const Text('Add Match', style: TextStyle(color: Colors.white))),
        body: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<SimplePlayersCubit, SimplePlayersState>(
              builder: (context, playersState) {
                return BlocBuilder<TeamsCubit, TeamsState>(
                  builder: (context, teamsState) {
                    return teamsState is TeamsLoaded &&
                            playersState is SimplePlayersLoaded
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyPopupMenu(
                                      data: playersState.players
                                          .map((p) => p.name)
                                          .toList(),
                                      onChanged: (v) => setState(() =>
                                          firstPlayerIndex = playersState
                                              .players
                                              .indexWhere((p) => p.name == v))),
                                  const SizedBox(height: 16),
                                  MyPopupMenu(
                                      data: teamsState.teams
                                          .map((t) => t.name)
                                          .toList(),
                                      onChanged: (v) => setState(() =>
                                          firstTeamIndex = teamsState.teams
                                              .indexWhere((t) => t.name == v))),
                                  const SizedBox(height: 16),
                                  MyPopupMenu(
                                      data: List.generate(
                                          14, (i) => i.toString()),
                                      onChanged: (v) => setState(
                                          () => firstTeamScore = int.parse(v))),
                                  const SizedBox(height: 16),
                                  const Text('VS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40)),
                                  const SizedBox(height: 16),
                                  MyPopupMenu(
                                      data: playersState.players
                                          .map((p) => p.name)
                                          .toList(),
                                      onChanged: (v) => secondPlayerIndex =
                                          playersState.players
                                              .indexWhere((p) => p.name == v)),
                                  const SizedBox(height: 16),
                                  MyPopupMenu(
                                      data: teamsState.teams
                                          .map((t) => t.name)
                                          .toList(),
                                      onChanged: (v) => setState(() =>
                                          secondTeamIndex = teamsState.teams
                                              .indexWhere((t) => t.name == v))),
                                  const SizedBox(height: 16),
                                  MyPopupMenu(
                                      data: List.generate(
                                          14, (i) => i.toString()),
                                      onChanged: (v) => setState(() =>
                                          secondTeamScore = int.parse(v))),
                                  const SizedBox(height: 64),
                                  BlocBuilder<MatchesCubit, MatchesState>(
                                    builder: (context, matchesState) {
                                      return matchesState is MatchesLoading
                                          ? const Loading()
                                          : AppElevatedButton(false, 'Done',
                                              () {
                                              if (firstPlayerIndex !=
                                                  secondPlayerIndex) {
                                                BlocProvider.of<MatchesCubit>(
                                                        context)
                                                    .addMatch(
                                                        Match(
                                                            teamsState.teams[
                                                                firstTeamIndex],
                                                            teamsState.teams[
                                                                secondTeamIndex],
                                                            firstTeamScore,
                                                            secondTeamScore,
                                                            'NA',
                                                            DateTime.now(),
                                                            widget.leagueId,
                                                            playersState
                                                                .players[
                                                                    firstPlayerIndex]
                                                                .id,
                                                            playersState
                                                                .players[
                                                                    secondPlayerIndex]
                                                                .id,
                                                            ''),
                                                        teamsState.teams);
                                              } else {
                                                FlutterToastHelper.showErrorToast(
                                                    'Pick different players');
                                              }
                                            }, .7);
                                    },
                                  )
                                ]),
                          )
                        : const Loading(size: 60);
                  },
                );
              },
            ),
          ),
        ));
  }
}
