import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/screens/profile_tabs/history.dart';
import 'package:road_to_the_throne/screens/profile_tabs/leagues.dart';
import 'package:road_to_the_throne/screens/profile_tabs/statistics.dart';
import 'package:road_to_the_throne/screens/standings.dart';
import 'package:road_to_the_throne/screens/teams.dart';
import 'package:road_to_the_throne/screens/add_match.dart';
import 'package:road_to_the_throne/widgets/appbar_header_item.dart';
import 'package:road_to_the_throne/widgets/loading.dart';

import 'add_league.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool loading = true;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    Future.delayed(Duration.zero).then((_) {
      Future.wait([
        BlocProvider.of<TeamsCubit>(context).getTeams(),
        BlocProvider.of<SimplePlayersCubit>(context).getSimplePlayers()
      ])
          .then((_) => Future.wait([
                BlocProvider.of<LeaguesCubit>(context).getCurrentUserLeagues(),
                BlocProvider.of<MatchesCubit>(context).getCurrentUserMatches(
                    (BlocProvider.of<TeamsCubit>(context).state as TeamsLoaded)
                        .teams)
              ]))
          .then((_) => BlocProvider.of<PlayerCubit>(context).getCurrentPlayer(
              (context.read<MatchesCubit>().state as MatchesLoaded).matches,
              (context.read<LeaguesCubit>().state as LeaguesLoaded).leagues));
    }).then((_) => setState(() => loading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<PlayerCubit, PlayerState>(
        builder: (context, state) {
          if (state is PlayerLoaded && !loading) {
            return Scaffold(
              appBar: AppBar(toolbarHeight: 0),
              floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => _tabController.index == 1
                              ? const AddLeague()
                              : const AddMatchScreen()))),
              body: SafeArea(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        forceElevated: innerBoxIsScrolled,
                        bottom: PreferredSize(
                          preferredSize: const Size(double.infinity, 116),
                          child: Column(children: [
                            Text(
                              state.player.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (c) => const TeamsScreen())),
                                  child: const AppBarHeaderItem(
                                      text: 'Teams',
                                      icon: Icons.sports_soccer_rounded,
                                      fontSize: 14),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(state.player.imageUrl),
                                      radius: 55),
                                ),
                                InkWell(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (c) =>
                                              const StandingsScreen())),
                                  child: const AppBarHeaderItem(
                                      text: 'Standings',
                                      icon: Icons.bar_chart_rounded,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: TabBar(
                            tabs: const <Tab>[
                              Tab(text: 'STATISTICS'),
                              Tab(text: 'LEAGUES'),
                              Tab(text: 'MATCHES'),
                            ],
                            labelStyle: const TextStyle(color: Colors.white),
                            controller: _tabController),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            BlocBuilder<PlayerCubit, PlayerState>(
                              builder: (context, state) {
                                if (state is PlayerLoaded) {
                                  return StatisticsTab(player: state.player);
                                } else {
                                  return const Loading(size: 50);
                                }
                              },
                            ),
                            const LeaguesTab(),
                            const MatchesHistoryTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Loading(size: 60));
        },
      ),
    );
  }
}
