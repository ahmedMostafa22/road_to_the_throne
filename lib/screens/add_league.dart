import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:road_to_the_throne/bloc/cubits/leagues/leagues_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/simple_players/simple_players_cubit.dart';
import 'package:road_to_the_throne/models/drop_down_item.dart';
import 'package:road_to_the_throne/models/league.dart';
import 'package:road_to_the_throne/models/simple_player.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_drop_down_menu.dart';
import 'package:road_to_the_throne/widgets/app_textfield.dart';

class AddLeague extends StatefulWidget {
  const AddLeague({Key? key}) : super(key: key);

  @override
  _AddLeagueState createState() => _AddLeagueState();
}

class _AddLeagueState extends State<AddLeague> {
  List<SimplePlayer> players = [], selectedPlayers = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    players = (context.read<SimplePlayersCubit>().state as SimplePlayersLoaded)
        .players;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Create League',
        style: TextStyle(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppTextField(
                controller: controller,
                label: 'League Name',
                validator: (n) => n!.isEmpty ? 'Field is required' : null),
            const SizedBox(height: 16),
            const Text(
              'Add Players to the league :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            MyPopupMenu(
                data: players.map((p) => DropDownItemModel(p.name, p.image)).toList(),
                onChanged: (v) {
                  if (selectedPlayers.where((p) => p.name == v.text).isEmpty) {
                    setState(() => selectedPlayers
                        .add(players.firstWhere((p) => p.name == v.text)));
                  }
                }),
            const SizedBox(height: 16),
            ListView.builder(
                shrinkWrap: true,
                itemCount: selectedPlayers.length,
                itemBuilder: (c, i) => Center(
                      child: Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(selectedPlayers[i].image),
                                  radius: 30),
                              const SizedBox(width: 8),
                              Text(
                                selectedPlayers[i].name,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                  onTap: () => setState(
                                      () => selectedPlayers.removeAt(i)),
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(width: 2))),
                    )), const SizedBox(height: 32),
            BlocBuilder<LeaguesCubit, LeaguesState>(
              builder: (context, leaguesState) {
                return AppElevatedButton(leaguesState is LeaguesLoading, 'Done',
                    () async {
                  if (selectedPlayers.isNotEmpty &&
                      controller.text.isNotEmpty) {
                    await BlocProvider.of<LeaguesCubit>(context).addLeague(
                        League(
                            'NA',
                            DateTime.now(),
                            '',
                            selectedPlayers.map((p) => p.id).toList(),
                            controller.text));
                    Navigator.pop(context);
                  }
                }, .7);
              },
            )
          ],
        ),
      ),
    );
  }
}
