import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_to_the_throne/bloc/cubits/matches/matches_cubit.dart';
import 'package:road_to_the_throne/widgets/loading.dart';
import 'package:road_to_the_throne/widgets/match_history_item.dart';

class MatchesHistoryTab extends StatelessWidget {
  const MatchesHistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesCubit, MatchesState>(
      builder: (context, state) {
        return state is MatchesLoaded
            ? ListView.builder(
                itemCount: state.matches.length,
                itemBuilder: (c, i) =>
                    MatchHistoryItem(match: state.matches[i]))
            : const Loading();
      },
    );
  }
}
