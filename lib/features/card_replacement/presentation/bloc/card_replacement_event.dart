import 'package:equatable/equatable.dart';

abstract class CardReplacementEvent extends Equatable {
  const CardReplacementEvent();

  @override
  List<Object?> get props => [];
}

class UpdateReasonEvent extends CardReplacementEvent {
  final String reason;
  const UpdateReasonEvent(this.reason);

  @override
  List<Object?> get props => [reason];
}

class UpdatePhoneNumberEvent extends CardReplacementEvent {
  final String phoneNumber;
  const UpdatePhoneNumberEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class UpdateStreetEvent extends CardReplacementEvent {
  final String street;
  const UpdateStreetEvent(this.street);

  @override
  List<Object?> get props => [street];
}

class UpdateStreetLine2Event extends CardReplacementEvent {
  final String streetLine2;
  const UpdateStreetLine2Event(this.streetLine2);

  @override
  List<Object?> get props => [streetLine2];
}

class UpdateCityEvent extends CardReplacementEvent {
  final String city;
  const UpdateCityEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class UpdateStateEvent extends CardReplacementEvent {
  final String state;
  const UpdateStateEvent(this.state);

  @override
  List<Object?> get props => [state];
}

class UpdateZipCodeEvent extends CardReplacementEvent {
  final String zipCode;
  const UpdateZipCodeEvent(this.zipCode);

  @override
  List<Object?> get props => [zipCode];
}

class SubmitCardRequestEvent extends CardReplacementEvent {
  const SubmitCardRequestEvent();
}

class ShowAcknowledgmentEvent extends CardReplacementEvent {
  const ShowAcknowledgmentEvent();
}

class ConfirmAcknowledgmentEvent extends CardReplacementEvent {
  const ConfirmAcknowledgmentEvent();
}

class CancelAcknowledgmentEvent extends CardReplacementEvent {
  const CancelAcknowledgmentEvent();
}

class ResetFormEvent extends CardReplacementEvent {
  const ResetFormEvent();
}
