import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/widgets/add_team_dialog.dart';
import 'package:road_to_the_throne/widgets/loading.dart';
import 'package:road_to_the_throne/widgets/team_item.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero, BlocProvider.of<TeamsCubit>(context).getTeams);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Teams',
        style: TextStyle(color: Colors.white),
      )),
      floatingActionButton: FirebaseAuth.instance.currentUser!.email ==
              'ahmed.sasa223344@gmail.com'
          ? FloatingActionButton(
              onPressed: () =>
                  showDialog(context: context, builder: (c) => AddTeamDialog()),
              child: const Icon(Icons.add, color: Colors.white))
          : null,
      body: BlocBuilder<TeamsCubit, TeamsState>(
        builder: (context, state) {
          return state is TeamsLoaded
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemCount: state.teams.length,
                      itemBuilder: (c, i) => TeamItem(team: state.teams[i])),
                )
              : const Loading(size: 60);
        },
      ),
    );
  }
}
