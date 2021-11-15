import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:road_to_the_throne/models/match.dart';
import 'package:road_to_the_throne/models/simple_player.dart';
import 'package:road_to_the_throne/models/table_item.dart';
import 'package:road_to_the_throne/screens/player_details_screen.dart';

class TableWidget extends StatefulWidget {
  const TableWidget({Key? key, required this.matches, required this.players})
      : super(key: key);
  final List<Match> matches;
  final List<SimplePlayer> players;

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  List<TableItem> tableItems = [];

  @override
  void initState() {
    calculateTableStandings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: const [
          Spacer(),
          SizedBox(
              width: 24,
              child: Text('P',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          SizedBox(
              width: 24,
              child: Text('W',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          SizedBox(
              width: 24,
              child: Text('D',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          SizedBox(
              width: 24,
              child: Text('L',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          SizedBox(
              width: 48,
              child: Text('Goals',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          SizedBox(
              width: 24,
              child: Text('PTS',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 16),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => InkWell(
                  onTap: () {
                    if (tableItems[i].player.id !=
                        FirebaseAuth.instance.currentUser!.uid) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => PlayerDetailsScreen(
                                  uid: tableItems[i].player.id)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(children: [
                      CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              i == 0 ? const Color(0xffffd900) : Colors.blue,
                          child: Text((i + 1).toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(width: 8),
                      CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              NetworkImage(tableItems[i].player.image)),
                      const SizedBox(width: 8),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(tableItems[i].player.name,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 10))),
                      const Spacer(),
                      SizedBox(
                          width: 24,
                          child: Text(tableItems[i].matchesCount.toString())),
                      SizedBox(
                          width: 24,
                          child: Text(tableItems[i].wins.toString())),
                      SizedBox(
                          width: 24,
                          child: Text(tableItems[i].losses.toString())),
                      SizedBox(
                          width: 24,
                          child: Text(tableItems[i].draws.toString())),
                      SizedBox(
                          width: 48,
                          child: Text(
                              '${tableItems[i].goalsScored}:${tableItems[i].goalsConceded}',
                              style: const TextStyle(fontSize: 12))),
                      SizedBox(
                          width: 24,
                          child: Text(tableItems[i].points.toString())),
                    ]),
                  ),
                ),
            itemCount: tableItems.length),
      ],
    );
  }

  void calculateTableStandings() {
    for (SimplePlayer player in widget.players) {
      TableItem tableItem = TableItem(0, 0, 0, player, 0, 0, 0, 0);
      for (Match m in widget.matches) {
        if (player.id == m.firstPlayerId && player.id == m.winnerPlayerId) {
          tableItem.points += 3;
          tableItem.wins++;
        } else if (player.id == m.secondPlayerId &&
            player.id == m.winnerPlayerId) {
          tableItem.points += 3;
          tableItem.wins++;
        } else if ((player.id == m.secondPlayerId ||
                player.id == m.firstPlayerId) &&
            m.winnerPlayerId == 'DRAW') {
          tableItem.points++;
          tableItem.draws++;
        } else if ((player.id == m.secondPlayerId ||
                player.id == m.firstPlayerId) &&
            m.winnerPlayerId != player.id) {
          tableItem.losses++;
        }
        if (player.id == m.firstPlayerId) {
          tableItem.matchesCount++;
          tableItem.goalsScored += m.firstScore;
          tableItem.goalsConceded += m.secondScore;
        } else if (player.id == m.secondPlayerId) {
          tableItem.matchesCount++;
          tableItem.goalsScored += m.secondScore;
          tableItem.goalsConceded += m.firstScore;
        }
        tableItems.add(tableItem);
      }
    }
    tableItems.sort((a, b) => b.points.compareTo(a.points));
    tableItems = tableItems.toSet().toList();
  }
}
