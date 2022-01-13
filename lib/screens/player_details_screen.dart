import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/player.dart';
import 'package:road_to_the_throne/screens/profile_tabs/statistics.dart';
import 'package:road_to_the_throne/widgets/loading.dart';
import 'package:road_to_the_throne/widgets/match_history_item.dart';

class PlayerDetailsScreen extends StatefulWidget {
  const PlayerDetailsScreen(
      {Key? key, required this.firstUid, required this.secondUid})
      : super(key: key);
  final String firstUid, secondUid;

  @override
  _PlayerDetailsScreenState createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  late Player player;

  List<Match> matches = [];

  bool loading = true;
  int firstPlayerWinsCount = 0,
      secondPlayerWinsCount = 0,
      difference = 0,
      draws = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      matches = await BlocProvider.of<MatchesCubit>(context).getVersusMatches(
          (context.read<TeamsCubit>().state as TeamsLoaded).teams,
          widget.firstUid,
          widget.secondUid);
      player = await BlocProvider.of<PlayerCubit>(context)
          .getPlayer(widget.firstUid);
      matches = matches
          .where((m) =>
              (m.firstPlayerId == widget.firstUid &&
                  m.secondPlayerId == widget.secondUid) ||
              (m.firstPlayerId == widget.secondUid &&
                  m.secondPlayerId == widget.firstUid))
          .toList();
      firstPlayerWinsCount =
          matches.where((m) => m.winnerPlayerId == player.id).length;
      secondPlayerWinsCount =
          matches.where((m) => m.winnerPlayerId == widget.secondUid).length;
      draws = matches.where((m) => m.winnerPlayerId == "DRAW").length;
      difference = (secondPlayerWinsCount - firstPlayerWinsCount).abs();
      setState(() => loading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: loading
          ? const Loading(size: 50)
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  player.name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(player.imageUrl),
                            radius: 55),
                      ),
                      StatisticsTab(player: player),
                      const SizedBox(height: 32),
                      const Text('History',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(player.imageUrl),
                              ),
                              const SizedBox(height: 16),
                              Text(firstPlayerWinsCount.toString() + ' Wins',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Column(
                            children: [
                              const Text('VS',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Text('Difference ' + difference.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Text('Draws ' + draws.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage((context
                                        .read<SimplePlayersCubit>()
                                        .state as SimplePlayersLoaded)
                                    .players
                                    .firstWhere((p) => p.id == widget.secondUid)
                                    .image),
                              ),
                              const SizedBox(height: 16),
                              Text(secondPlayerWinsCount.toString() + ' Wins',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: matches.length,
                          itemBuilder: (c, i) =>
                              MatchHistoryItem(match: matches[i])),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              )),
    );
  }
}
