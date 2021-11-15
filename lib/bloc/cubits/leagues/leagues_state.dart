part of 'leagues_cubit.dart';

@immutable
abstract class LeaguesState {}

class LeaguesInitial extends LeaguesState {}

class LeaguesLoading extends LeaguesState {}

class LeaguesLoaded extends LeaguesState {
  final List<League> leagues;

  LeaguesLoaded(this.leagues);
}

class LeaguesError extends LeaguesState {}
