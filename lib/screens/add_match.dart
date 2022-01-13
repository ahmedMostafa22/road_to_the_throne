import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/helpers/flutter_toast.dart';
import 'package:road_to_the_throne/models/drop_down_item.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/simple_player.dart';
import 'package:road_to_the_throne/models/team.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_drop_down_menu.dart';
import 'package:road_to_the_throne/widgets/loading.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen(
      {Key? key,
      this.leagueId = 'NA',
      required this.players,
      required this.teams})
      : super(key: key);
  final String leagueId;
  final List<SimplePlayer> players;
  final List<Team> teams;

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
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        MyPopupMenu(
                            data: widget.players
                                .map((p) => DropDownItemModel(p.name, p.image))
                                .toList(),
                            onChanged: (v) => setState(() => firstPlayerIndex =
                                widget.players
                                    .indexWhere((p) => p.name == v.text))),
                        const SizedBox(height: 16),
                        MyPopupMenu(
                            data: widget.teams
                                .map((t) => DropDownItemModel(t.name, t.image))
                                .toList(),
                            onChanged: (v) => setState(() => firstTeamIndex =
                                widget.teams
                                    .indexWhere((t) => t.name == v.text))),
                        const SizedBox(height: 16),
                        MyPopupMenu(
                            data: List.generate(14,
                                (i) => DropDownItemModel(i.toString(), null)),
                            onChanged: (v) => setState(
                                () => firstTeamScore = int.parse(v.text))),
                        const SizedBox(height: 16),
                        const Text('VS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40)),
                        const SizedBox(height: 16),
                        MyPopupMenu(
                            data: widget.players
                                .map((p) => DropDownItemModel(p.name, p.image))
                                .toList(),
                            onChanged: (v) => secondPlayerIndex = widget.players
                                .indexWhere((p) => p.name == v.text)),
                        const SizedBox(height: 16),
                        MyPopupMenu(
                            data: widget.teams
                                .map((t) => DropDownItemModel(t.name, t.image))
                                .toList(),
                            onChanged: (v) => setState(() => secondTeamIndex =
                                widget.teams
                                    .indexWhere((t) => t.name == v.text))),
                        const SizedBox(height: 16),
                        MyPopupMenu(
                            data: List.generate(14,
                                (i) => DropDownItemModel(i.toString(), null)),
                            onChanged: (v) => setState(
                                () => secondTeamScore = int.parse(v.text))),
                        const SizedBox(height: 64),
                        BlocBuilder<MatchesCubit, MatchesState>(
                          builder: (context, matchesState) {
                            return matchesState is MatchesLoading
                                ? const Loading()
                                : AppElevatedButton(false, 'Done', () {
                                    if (firstPlayerIndex != secondPlayerIndex) {
                                      BlocProvider.of<MatchesCubit>(context)
                                          .addMatch(
                                              Match(
                                                  widget.teams[firstTeamIndex],
                                                  widget.teams[secondTeamIndex],
                                                  firstTeamScore,
                                                  secondTeamScore,
                                                  'NA',
                                                  DateTime.now(),
                                                  widget.leagueId,
                                                  widget
                                                      .players[firstPlayerIndex]
                                                      .id,
                                                  widget
                                                      .players[
                                                          secondPlayerIndex]
                                                      .id,
                                                  ''),
                                              widget.teams);
                                    } else {
                                      FlutterToastHelper.showErrorToast(
                                          'Pick different players');
                                    }
                                  }, .7);
                          },
                        )
                      ]),
                    );
                  },
                );
              },
            ),
          ),
        ));
  }
}
