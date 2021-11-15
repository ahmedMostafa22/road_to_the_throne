part of 'simple_players_cubit.dart';

@immutable
abstract class SimplePlayersState {}

class SimplePlayersInitial extends SimplePlayersState {}

class SimplePlayersLoaded extends SimplePlayersState {
  final List<SimplePlayer> players ;

  SimplePlayersLoaded(this.players);
}

class SimplePlayersLoading extends SimplePlayersState {}

class SimplePlayersError extends SimplePlayersState {}
