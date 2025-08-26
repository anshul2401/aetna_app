import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ReimbursementEvent extends Equatable {
  const ReimbursementEvent();

  @override
  List<Object?> get props => [];
}

class UpdateDescriptionEvent extends ReimbursementEvent {
  final String description;
  const UpdateDescriptionEvent(this.description);

  @override
  List<Object?> get props => [description];
}

class UpdateCategoryEvent extends ReimbursementEvent {
  final String category;
  const UpdateCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class UpdateProviderEvent extends ReimbursementEvent {
  final String provider;
  const UpdateProviderEvent(this.provider);

  @override
  List<Object?> get props => [provider];
}

class UpdateAmountEvent extends ReimbursementEvent {
  final double amount;
  const UpdateAmountEvent(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateDateEvent extends ReimbursementEvent {
  final DateTime date;
  const UpdateDateEvent(this.date);

  @override
  List<Object?> get props => [date];
}

class UpdateNotesEvent extends ReimbursementEvent {
  final String notes;
  const UpdateNotesEvent(this.notes);

  @override
  List<Object?> get props => [notes];
}

// Changed from single file to multiple files
class AddFilesEvent extends ReimbursementEvent {
  final List<File> files;
  const AddFilesEvent(this.files);

  @override
  List<Object?> get props => [files];
}

// New event to remove a specific file
class RemoveFileEvent extends ReimbursementEvent {
  final File file;
  const RemoveFileEvent(this.file);

  @override
  List<Object?> get props => [file];
}

// Keep the old event for backward compatibility but mark as deprecated
@deprecated
class UpdateFileEvent extends ReimbursementEvent {
  final File? file;
  const UpdateFileEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class SubmitReimbursementEvent extends ReimbursementEvent {
  const SubmitReimbursementEvent();
}

class ResetFormEvent extends ReimbursementEvent {
  const ResetFormEvent();
}
