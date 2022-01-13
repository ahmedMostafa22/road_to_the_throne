import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/player/player_cubit.dart';
import 'package:road_to_the_throne/models/team.dart';

class TeamItem extends StatelessWidget {
  final Team team;

  const TeamItem({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (context.read<PlayerCubit>().state as PlayerLoaded)
                  .player
                  .favoriteTeam ==
              team.id
          ? Colors.indigoAccent[100]
          : Colors.white,
      child: InkWell(
        onTap: () async {
          await BlocProvider.of<PlayerCubit>(context).updatePlayer(
              {'favTeam': team.id}, FirebaseAuth.instance.currentUser!.uid);
          Navigator.pop(context);
        },
        child: Column(
          children: [
            Image.network(team.image,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * .25,
                height: MediaQuery.of(context).size.width * .25),
            Text(
              team.name,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
