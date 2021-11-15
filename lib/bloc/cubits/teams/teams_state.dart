part of 'teams_cubit.dart';

@immutable
abstract class TeamsState {}

class TeamsInitial extends TeamsState {}

class TeamsLoading extends TeamsState {}

class TeamsLoaded extends TeamsState {
  final List<Team> teams;
  TeamsLoaded(this.teams);
}

class TeamsError extends TeamsState {}
