import 'package:flutter/material.dart';
import 'package:road_to_the_throne/constants/assets.dart';
import 'package:road_to_the_throne/models/player.dart';
import 'package:road_to_the_throne/widgets/stats_item.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({Key? key, required this.player}) : super(key: key);
  final Player player;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.trophie, width: 50),
              const SizedBox(width: 8),
              const Text('Leagues',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              StatisticsItem(
                  t1: player.wonLeaguesCount.toString(), t2: 'Titles'),
              const Spacer(),
              StatisticsItem(
                  t1: player.leaguesParticipationCount.toString(),
                  t2: 'Played'),
              const Spacer(),
              StatisticsItem(
                  t1: ((player.wonLeaguesCount /
                                  (player.leaguesParticipationCount == 0
                                      ? 1
                                      : player.leaguesParticipationCount)) *
                              100)
                          .toInt()
                          .toString() +
                      ' %',
                  t2: 'Win rate'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.ball, width: 50),
              const SizedBox(width: 8),
              const Text('Matches',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              StatisticsItem(t1: player.winsCount.toString(), t2: 'Wins'),
              const Spacer(),
              StatisticsItem(t1: player.lossesCount.toString(), t2: 'Losses'),
              const Spacer(),
              StatisticsItem(t1: player.drawsCount.toString(), t2: 'Draws'),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.net, width: 50),
              const SizedBox(width: 8),
              const Text('Goals',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Spacer(),
              StatisticsItem(
                  t1: player.goalsScored.toString(), t2: 'Goals Scored'),
              const Spacer(),
              StatisticsItem(
                  t1: player.goalsConceded.toString(), t2: 'Goals Conceded'),
              const Spacer(),
              StatisticsItem(
                  t1: (player.goalsScored - player.goalsConceded).toString(),
                  t2: 'Difference'),
              const Spacer(),
            ],
          ),
        ]),
      ),
    );
  }
}
