import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'reimbursement_event.dart';
import 'reimbursement_state.dart';

class ReimbursementBloc extends Bloc<ReimbursementEvent, ReimbursementState> {
  // TODO: Inject ReimbursementRepository via constructor
  // final ReimbursementRepository _repository;

  static const List<String> categories = [
    'Rent',
    'Power',
    'Water',
    'Medical',
    'OTC',
    'Personal',
    'Transportation',
    'Food',
  ];

  ReimbursementBloc() : super(const ReimbursementState()) {
    on<UpdateDescriptionEvent>(_onUpdateDescription);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<UpdateProviderEvent>(_onUpdateProvider);
    on<UpdateAmountEvent>(_onUpdateAmount);
    on<UpdateDateEvent>(_onUpdateDate);
    on<UpdateNotesEvent>(_onUpdateNotes);
    on<AddFilesEvent>(_onAddFiles);
    on<RemoveFileEvent>(_onRemoveFile);
    on<UpdateFileEvent>(_onUpdateFile); // Keep for backward compatibility
    on<SubmitReimbursementEvent>(_onSubmitReimbursement);
    on<ResetFormEvent>(_onResetForm);
  }

  void _onUpdateDescription(
    UpdateDescriptionEvent event,
    Emitter<ReimbursementState> emit,
  ) {
    emit(
      state.copyWith(
        description: event.description,
        isFormValid: _isFormValid(description: event.description),
      ),
    );
  }

  void _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<ReimbursementState> emit,
  ) {
    emit(
      state.copyWith(
        category: event.category,
        isFormValid: _isFormValid(category: event.category),
      ),
    );
  }

  void _onUpdateProvider(
    UpdateProviderEvent event,
    Emitter<ReimbursementState> emit,
  ) {
    emit(
      state.copyWith(
        provider: event.provider,
        isFormValid: _isFormValid(provider: event.provider),
      ),
    );
  }

  void _onUpdateAmount(
    UpdateAmountEvent event,
    Emitter<ReimbursementState> emit,
  ) {
    emit(
      state.copyWith(
        amount: event.amount,
        isFormValid: _isFormValid(amount: event.amount),
      ),
    );
  }

  void _onUpdateDate(UpdateDateEvent event, Emitter<ReimbursementState> emit) {
    emit(
      state.copyWith(
        purchaseDate: event.date,
        isFormValid: _isFormValid(purchaseDate: event.date),
      ),
    );
  }

  void _onUpdateNotes(
    UpdateNotesEvent event,
    Emitter<ReimbursementState> emit,
  ) {
    emit(
      state.copyWith(
        notes: event.notes,
        isFormValid: _isFormValid(notes: event.notes),
      ),
    );
  }

  void _onAddFiles(AddFilesEvent event, Emitter<ReimbursementState> emit) {
    final updatedFiles = List<File>.from(state.attachedFiles)
      ..addAll(event.files);
    emit(
      state.copyWith(
        attachedFiles: updatedFiles,
        isFormValid: _isFormValid(attachedFiles: updatedFiles),
      ),
    );
  }

  void _onRemoveFile(RemoveFileEvent event, Emitter<ReimbursementState> emit) {
    final updatedFiles = List<File>.from(state.attachedFiles)
      ..removeWhere((file) => file.path == event.file.path);
    emit(
      state.copyWith(
        attachedFiles: updatedFiles,
        isFormValid: _isFormValid(attachedFiles: updatedFiles),
      ),
    );
  }

  // Keep for backward compatibility
  void _onUpdateFile(UpdateFileEvent event, Emitter<ReimbursementState> emit) {
    if (event.file != null) {
      add(AddFilesEvent([event.file!]));
    }
  }

  Future<void> _onSubmitReimbursement(
    SubmitReimbursementEvent event,
    Emitter<ReimbursementState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: ReimbursementStatus.failure,
          errorMessage: 'Please fill all required fields',
        ),
      );
      return;
    }

    emit(state.copyWith(status: ReimbursementStatus.loading));

    try {
      // TODO: Replace with actual repository call
      // final result = await _repository.submitReimbursement(
      //   description: state.description,
      //   category: state.category,
      //   provider: state.provider,
      //   amount: state.amount,
      //   purchaseDate: state.purchaseDate!,
      //   notes: state.notes,
      //   attachedFiles: state.attachedFiles,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: ReimbursementStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: ReimbursementStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void _onResetForm(ResetFormEvent event, Emitter<ReimbursementState> emit) {
    emit(const ReimbursementState());
  }

  bool _isFormValid({
    String? description,
    String? category,
    String? provider,
    double? amount,
    DateTime? purchaseDate,
    String? notes,
    List<File>? attachedFiles,
  }) {
    final currentDescription = description ?? state.description;
    final currentProvider = provider ?? state.provider;
    final currentAmount = amount ?? state.amount;
    final currentDate = purchaseDate ?? state.purchaseDate;

    return currentDescription.trim().isNotEmpty &&
        currentProvider.trim().isNotEmpty &&
        currentAmount > 0 &&
        currentDate != null;
  }

  // Helper method to pick multiple files
  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: true, // Enable multiple file selection
      );

      if (result != null) {
        final files = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
        add(AddFilesEvent(files));
      }
    } catch (e) {
      // Handle error if needed
    }
  }
}
