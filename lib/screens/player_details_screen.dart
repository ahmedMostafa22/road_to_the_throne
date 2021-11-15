import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/player.dart';
import 'package:road_to_the_throne/screens/profile_tabs/statistics.dart';
import 'package:road_to_the_throne/widgets/loading.dart';
import 'package:road_to_the_throne/widgets/match_history_item.dart';

class PlayerDetailsScreen extends StatefulWidget {
  const PlayerDetailsScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _PlayerDetailsScreenState createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> {
  late Player player;
  List<Match> matches = [];

  bool loading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      matches = await BlocProvider.of<MatchesCubit>(context).getUserMatches(
          (context.read<TeamsCubit>().state as TeamsLoaded).teams, widget.uid);
      player = await BlocProvider.of<PlayerCubit>(context).getPlayer(
          matches,
          (context.read<LeaguesCubit>().state as LeaguesLoaded).leagues,
          widget.uid);
      matches = matches
          .where((m) =>
              (m.firstPlayerId == widget.uid &&
                  m.secondPlayerId == FirebaseAuth.instance.currentUser!.uid) ||
              (m.firstPlayerId == FirebaseAuth.instance.currentUser!.uid &&
                  m.secondPlayerId == widget.uid))
          .toList();
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
