import 'package:road_to_the_throne/models/simple_player.dart';

class TableItem {
  int points, goalsScored, goalsConceded, matchesCount, wins, draws, losses;
  final SimplePlayer player;

  TableItem(this.points, this.goalsScored, this.goalsConceded, this.player,
      this.matchesCount, this.wins, this.draws, this.losses);
}
