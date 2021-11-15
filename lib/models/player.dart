import 'package:road_to_the_throne/models/team.dart';

class Player {
  final String id, name, imageUrl;
  final int wonLeaguesCount,
      leaguesParticipationCount,
      gamesCount,
      winsCount,
      lossesCount,
      drawsCount,
      goalsScored,
      goalsConceded;

  Player(
      this.id,
      this.name,
      this.imageUrl,
      this.wonLeaguesCount,
      this.gamesCount,
      this.winsCount,
      this.lossesCount,
      this.drawsCount,
      this.goalsScored,
      this.goalsConceded,
      this.leaguesParticipationCount);
}
