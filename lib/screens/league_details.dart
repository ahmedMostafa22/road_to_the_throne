import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/models/drop_down_item.dart';
import 'package:road_to_the_throne/models/league.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/simple_player.dart';
import 'package:road_to_the_throne/screens/add_match.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_drop_down_menu.dart';
import 'package:road_to_the_throne/widgets/loading.dart';
import 'package:road_to_the_throne/widgets/match_history_item.dart';
import 'package:road_to_the_throne/widgets/table.dart';

class LeagueDetailsScreen extends StatefulWidget {
  const LeagueDetailsScreen({Key? key, required this.league}) : super(key: key);
  final League league;

  @override
  _LeagueDetailsScreenState createState() => _LeagueDetailsScreenState();
}

class _LeagueDetailsScreenState extends State<LeagueDetailsScreen> {
  bool matchesLoading = true;
  List<Match> matches = [];
  List<SimplePlayer> players = [];
  int selectedPlayerIndex = 0;

  @override
  void initState() {
    super.initState();
    for (String pId in widget.league.playersIds) {
      players.add(
          (context.read<SimplePlayersCubit>().state as SimplePlayersLoaded)
              .players
              .firstWhere((p) => p.id == pId));
    }
    Future.delayed(Duration.zero, () async {
      matches = await BlocProvider.of<MatchesCubit>(context).getLeagueMatches(
          widget.league.id,
          (context.read<TeamsCubit>().state as TeamsLoaded).teams);
      setState(() => matchesLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.league.name,
              style: const TextStyle(color: Colors.white))),
      floatingActionButton: widget.league.winnerPlayerId != 'NA' ||
              !widget.league.playersIds
                  .contains(FirebaseAuth.instance.currentUser!.uid)
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => AddMatchScreen(
                          leagueId: widget.league.id,
                          players: players,
                          teams: (BlocProvider.of<TeamsCubit>(context).state
                                  as TeamsLoaded)
                              .teams)))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!matchesLoading && matches.isNotEmpty)
                const Text('Standings :',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (!matchesLoading && matches.isNotEmpty)
                const SizedBox(height: 16),
              if (!matchesLoading && matches.isNotEmpty)
                TableWidget(matches: matches, players: players),
              const SizedBox(height: 32),
              if (!matchesLoading && matches.isNotEmpty)
                const Text('Matches :',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              matchesLoading
                  ? const Loading(size: 40)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: matches.length,
                      itemBuilder: (c, i) =>
                          MatchHistoryItem(match: matches[i])),
              const SizedBox(height: 32),
              if (widget.league.winnerPlayerId == 'NA')
                Center(
                  child: BlocBuilder<LeaguesCubit, LeaguesState>(
                    builder: (context, leaguesState) {
                      return AppElevatedButton(
                          leaguesState is LeaguesLoading, 'Decide Winner',
                          () async {
                        await showDialog(
                            context: context,
                            builder: (c) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: MyPopupMenu(
                                        data: players
                                            .map((p) => DropDownItemModel(
                                                p.name, p.image))
                                            .toList(),
                                        onChanged: (v) async {
                                          await BlocProvider.of<LeaguesCubit>(
                                                  context)
                                              .setLeagueWinner(
                                                  widget.league.id,
                                                  players
                                                      .firstWhere((p) =>
                                                          p.name == v.text)
                                                      .id);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }),
                                  ),
                                ));
                      }, .7);
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
