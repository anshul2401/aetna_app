import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<NavigateToReimbursementEvent>(_onNavigateToReimbursement);
    on<NavigateToReplacementCardEvent>(_onNavigateToReplacementCard);
    on<ResetNavigationEvent>(_onResetNavigation);
  }

  void _onNavigateToReimbursement(
    NavigateToReimbursementEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      status: HomeStatus.navigatingToReimbursement,
      message: 'Opening Reimbursement Claims...',
    ));
  }

  void _onNavigateToReplacementCard(
    NavigateToReplacementCardEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      status: HomeStatus.navigatingToReplacementCard,
      message: 'Opening Replacement Card Request...',
    ));
  }

  void _onResetNavigation(
    ResetNavigationEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(status: HomeStatus.initial));
  }
}
