import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:road_to_the_throne/models/team.dart';

class Match {
  final Team firstTeam, secondTeam;
  final int firstScore, secondScore;
  final String id, winnerPlayerId, leagueId, firstPlayerId, secondPlayerId;
  final DateTime date;

  Match(
      this.firstTeam,
      this.secondTeam,
      this.firstScore,
      this.secondScore,
      this.winnerPlayerId,
      this.date,
      this.leagueId,
      this.firstPlayerId,
      this.secondPlayerId,
      this.id);

  static Match fromFirestore(DocumentSnapshot doc, List<Team> teams) => Match(
      teams.firstWhere((t) => t.id == doc.get('firstTeam')),
      teams.firstWhere((t) => t.id == doc.get('secondTeam')),
      doc.get('firstScore'),
      doc.get('secondScore'),
      doc.get('winnerPlayerId'),
      DateTime.parse(doc.get('date')),
      doc.get('leagueId'),
      doc.get('firstPlayerId'),
      doc.get('secondPlayerId'),
      doc.id);

  Map<String, dynamic> toMap() => {
        'firstTeam': firstTeam.id,
        'secondTeam': secondTeam.id,
        'firstScore': firstScore,
        'secondScore': secondScore,
        'winnerPlayerId': getMatchWinnerId(),
        'date': date.toIso8601String(),
        'leagueId': leagueId,
        'firstPlayerId': firstPlayerId,
        'secondPlayerId': secondPlayerId
      };

  String getMatchWinnerId() => firstScore > secondScore
      ? firstPlayerId
      : secondScore > firstScore
          ? secondPlayerId
          : 'DRAW';
}
