import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/image_picker/image_picker_cubit.dart';
import 'package:road_to_the_throne/bloc/cubits/teams/teams_cubit.dart';
import 'package:road_to_the_throne/helpers/firebase_storage.dart';
import 'package:road_to_the_throne/models/team.dart';
import 'package:road_to_the_throne/widgets/app_btn.dart';
import 'package:road_to_the_throne/widgets/app_outlined_btn.dart';
import 'package:road_to_the_throne/widgets/app_textfield.dart';
import 'package:road_to_the_throne/widgets/image_picker.dart';

import 'loading.dart';

class AddTeamDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  AddTeamDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ImagePicker(),
          AppTextField(
              label: 'Team Name',
              validator: (n) => n!.isEmpty ? 'Please enter your name' : null,
              controller: controller),
          const SizedBox(height: 16),
          BlocBuilder<TeamsCubit, TeamsState>(
            builder: (context, state) {
              return state is TeamsLoading
                  ? const Loading()
                  : AppElevatedButton(false, 'Add Team', () async {
                      await BlocProvider.of<TeamsCubit>(context)
                          .addTeam(Team('', controller.text, ''), context);
                      Navigator.of(context).pop();
                    }, .5);
            },
          )
        ],
      ),
    ));
  }
}
