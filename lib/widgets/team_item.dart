import 'package:flutter/material.dart';
import 'package:road_to_the_throne/models/team.dart';

class TeamItem extends StatelessWidget {
  final Team team;

  const TeamItem({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
