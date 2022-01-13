import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/models/league.dart';
import 'package:road_to_the_throne/models/simple_player.dart';
import 'package:road_to_the_throne/models/standing_item.dart';
import 'package:road_to_the_throne/screens/player_details_screen.dart';

class StandingsScreen extends StatefulWidget {
  const StandingsScreen({Key? key}) : super(key: key);

  @override
  _StandingsScreenState createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  List<SimplePlayer> players = [];
  List<League> leagues = [];
  List<StandingItem> items = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    players = (context.read<SimplePlayersCubit>().state as SimplePlayersLoaded)
        .players;
    leagues = (context.read<LeaguesCubit>().state as LeaguesLoaded).leagues;
    for (SimplePlayer p in players) {
      items.add(StandingItem(
          p, leagues.where((l) => l.winnerPlayerId == (p.id)).length));
    }
    items.sort((a, b) => b.trophies.compareTo(a.trophies));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Standings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.builder(
            itemBuilder: (c, i) => InkWell(
                  onTap: () {
                    if (items[i].player.id !=
                        FirebaseAuth.instance.currentUser!.uid) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => PlayerDetailsScreen(
                                  firstUid: items[i].player.id,
                                  secondUid:
                                      FirebaseAuth.instance.currentUser!.uid)));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                            backgroundColor:
                                i == 0 ? const Color(0xffffd900) : Colors.blue,
                            child: Text((i + 1).toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundImage: NetworkImage(items[i].player.image),
                        ),
                        const SizedBox(width: 8),
                        Text(items[i].player.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text(items[i].trophies.toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
            itemCount: items.length));
  }
}
