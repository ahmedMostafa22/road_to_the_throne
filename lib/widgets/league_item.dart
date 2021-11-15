import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/constants/assets.dart';
import 'package:road_to_the_throne/models/league.dart';
import 'package:road_to_the_throne/screens/league_details.dart';

class LeagueItem extends StatelessWidget {
  const LeagueItem({Key? key, required this.league}) : super(key: key);
  final League league;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      highlightColor: Colors.grey,
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => LeagueDetailsScreen(league: league))),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: Image.asset(Assets.splash, color: Colors.white)),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(league.name,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(league.date.toIso8601String().substring(0, 10),
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            if (league.winnerPlayerId != 'NA')
              Row(
                children: [
                  const Text('Winner :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all(width: 2)),
                    child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage((context
                                .read<SimplePlayersCubit>()
                                .state as SimplePlayersLoaded)
                            .players
                            .firstWhere((p) => p.id == league.winnerPlayerId)
                            .image)),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
