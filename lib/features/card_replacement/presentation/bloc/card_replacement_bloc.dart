import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_replacement_event.dart';
import 'card_replacement_state.dart';

class CardReplacementBloc extends Bloc<CardReplacementEvent, CardReplacementState> {
  // TODO: Inject CardRepository via constructor
  // final CardRepository _repository;

  static const List<String> reasons = [
    'Lost Card',
    'Stolen',
    'Damaged',
    'Never Received',
  ];

  static const List<String> usStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
    'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho',
    'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
    'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
    'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
    'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
    'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
    'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
    'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
    'West Virginia', 'Wisconsin', 'Wyoming'
  ];

  CardReplacementBloc() : super(const CardReplacementState()) {
    on<UpdateReasonEvent>(_onUpdateReason);
    on<UpdatePhoneNumberEvent>(_onUpdatePhoneNumber);
    on<UpdateStreetEvent>(_onUpdateStreet);
    on<UpdateStreetLine2Event>(_onUpdateStreetLine2);
    on<UpdateCityEvent>(_onUpdateCity);
    on<UpdateStateEvent>(_onUpdateState);
    on<UpdateZipCodeEvent>(_onUpdateZipCode);
    on<SubmitCardRequestEvent>(_onSubmitCardRequest);
    on<ShowAcknowledgmentEvent>(_onShowAcknowledgment);
    on<ConfirmAcknowledgmentEvent>(_onConfirmAcknowledgment);
    on<CancelAcknowledgmentEvent>(_onCancelAcknowledgment);
    on<ResetFormEvent>(_onResetForm);
  }

  void _onUpdateReason(UpdateReasonEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      reason: event.reason,
      isFormValid: _isFormValid(reason: event.reason),
    ));
  }

  void _onUpdatePhoneNumber(UpdatePhoneNumberEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      phoneNumber: event.phoneNumber,
      isFormValid: _isFormValid(phoneNumber: event.phoneNumber),
    ));
  }

  void _onUpdateStreet(UpdateStreetEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      street: event.street,
      isFormValid: _isFormValid(street: event.street),
    ));
  }

  void _onUpdateStreetLine2(UpdateStreetLine2Event event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      streetLine2: event.streetLine2,
      isFormValid: _isFormValid(streetLine2: event.streetLine2),
    ));
  }

  void _onUpdateCity(UpdateCityEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      city: event.city,
      isFormValid: _isFormValid(city: event.city),
    ));
  }

  void _onUpdateState(UpdateStateEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      state: event.state,
      isFormValid: _isFormValid(state: event.state),
    ));
  }

  void _onUpdateZipCode(UpdateZipCodeEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(
      zipCode: event.zipCode,
      isFormValid: _isFormValid(zipCode: event.zipCode),
    ));
  }

  void _onSubmitCardRequest(SubmitCardRequestEvent event, Emitter<CardReplacementState> emit) {
    if (!state.isFormValid) {
      emit(state.copyWith(
        status: CardReplacementStatus.failure,
        errorMessage: 'Please fill all required fields',
      ));
      return;
    }
    
    // Show acknowledgment screen first
    emit(state.copyWith(status: CardReplacementStatus.showingAcknowledgment));
  }

  void _onShowAcknowledgment(ShowAcknowledgmentEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(status: CardReplacementStatus.showingAcknowledgment));
  }

  Future<void> _onConfirmAcknowledgment(ConfirmAcknowledgmentEvent event, Emitter<CardReplacementState> emit) async {
    emit(state.copyWith(status: CardReplacementStatus.submitting));

    try {
      // TODO: Replace with actual repository call
      // final result = await _repository.submitCardRequest(
      //   reason: state.reason,
      //   phoneNumber: state.phoneNumber,
      //   street: state.street,
      //   streetLine2: state.streetLine2,
      //   city: state.city,
      //   state: state.state,
      //   zipCode: state.zipCode,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: CardReplacementStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: CardReplacementStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onCancelAcknowledgment(CancelAcknowledgmentEvent event, Emitter<CardReplacementState> emit) {
    emit(state.copyWith(status: CardReplacementStatus.initial));
  }

  void _onResetForm(ResetFormEvent event, Emitter<CardReplacementState> emit) {
    emit(const CardReplacementState());
  }

  bool _isFormValid({
    String? reason,
    String? phoneNumber,
    String? street,
    String? streetLine2,
    String? city,
    String? state,
    String? zipCode,
  }) {
    final currentReason = reason ?? this.state.reason;
    final currentPhoneNumber = phoneNumber ?? this.state.phoneNumber;
    final currentStreet = street ?? this.state.street;
    final currentCity = city ?? this.state.city;
    final currentState = state ?? this.state.state;
    final currentZipCode = zipCode ?? this.state.zipCode;

    return currentReason.trim().isNotEmpty &&
           currentPhoneNumber.trim().isNotEmpty &&
           currentStreet.trim().isNotEmpty &&
           currentCity.trim().isNotEmpty &&
           currentState.trim().isNotEmpty &&
           currentZipCode.trim().isNotEmpty;
  }
}
