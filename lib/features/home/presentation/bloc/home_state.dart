import 'package:equatable/equatable.dart';

enum HomeStatus { initial, navigatingToReimbursement, navigatingToReplacementCard }

class HomeState extends Equatable {
  final HomeStatus status;
  final String? message;

  const HomeState({
    this.status = HomeStatus.initial,
    this.message,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
