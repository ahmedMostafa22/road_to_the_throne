part of 'matches_cubit.dart';

@immutable
abstract class MatchesState {}

class MatchesInitial extends MatchesState {}

class MatchesLoading extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<Match> matches;

  MatchesLoaded(this.matches);
}

class MatchesError extends MatchesState {}
