import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/simple_player.dart';
import 'package:road_to_the_throne/screens/player_details_screen.dart';

class MatchHistoryItem extends StatelessWidget {
  const MatchHistoryItem({Key? key, required this.match}) : super(key: key);
  final Match match;

  @override
  Widget build(BuildContext context) {
    final SimplePlayer firstPlayer =
        (context.read<SimplePlayersCubit>().state as SimplePlayersLoaded)
            .players
            .firstWhere((p) => match.firstPlayerId == p.id);
    final SimplePlayer secondPlayer =
        (context.read<SimplePlayersCubit>().state as SimplePlayersLoaded)
            .players
            .firstWhere((p) => match.secondPlayerId == p.id);
    return InkWell(
      onDoubleTap: () =>
          BlocProvider.of<MatchesCubit>(context).deleteMatch(match.id),
      onTap: () {
        String uid = firstPlayer.id == FirebaseAuth.instance.currentUser!.uid
            ? secondPlayer.id
            : secondPlayer.id == FirebaseAuth.instance.currentUser!.uid
                ? firstPlayer.id
                : '';
        if (uid.isEmpty) return;
        Navigator.push(context,
            MaterialPageRoute(builder: (c) => PlayerDetailsScreen(uid: uid)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: Colors.white,
                foregroundImage: NetworkImage(firstPlayer.image),
                radius: 30),
            const SizedBox(width: 8),
            CircleAvatar(
                backgroundColor: Colors.white,
                foregroundImage: NetworkImage(match.firstTeam.image),
                radius: 30),
            const SizedBox(width: 16),
            Text(
              match.firstScore.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            const SizedBox(width: 4),
            const Text(
              '-',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(width: 4),
            Text(
              match.secondScore.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
                backgroundColor: Colors.white,
                foregroundImage: NetworkImage(match.secondTeam.image),
                radius: 30),
            const SizedBox(width: 8),
            CircleAvatar(
                backgroundColor: Colors.white,
                foregroundImage: NetworkImage(secondPlayer.image),
                radius: 30),
          ],
        ),
      ),
    );
  }
}
