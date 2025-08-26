import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class NavigateToReimbursementEvent extends HomeEvent {
  const NavigateToReimbursementEvent();
}

class NavigateToReplacementCardEvent extends HomeEvent {
  const NavigateToReplacementCardEvent();
}

class ResetNavigationEvent extends HomeEvent {
  const ResetNavigationEvent();
}
