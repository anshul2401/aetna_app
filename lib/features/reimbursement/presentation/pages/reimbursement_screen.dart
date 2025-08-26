import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/reimbursement_bloc.dart';
import '../bloc/reimbursement_event.dart';
import '../bloc/reimbursement_state.dart';

class ReimbursementScreen extends StatelessWidget {
  const ReimbursementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReimbursementBloc(),
      child: const ReimbursementScreenView(),
    );
  }
}

class ReimbursementScreenView extends StatefulWidget {
  const ReimbursementScreenView({Key? key}) : super(key: key);

  @override
  State<ReimbursementScreenView> createState() =>
      _ReimbursementScreenViewState();
}

class _ReimbursementScreenViewState extends State<ReimbursementScreenView> {
  final _descriptionController = TextEditingController();
  final _providerController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  int _selectedImageIndex = 0;
  PageController _pageController = PageController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _providerController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final bloc = context.read<ReimbursementBloc>();
    final currentDate = bloc.state.purchaseDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007BFF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      bloc.add(UpdateDateEvent(picked));
    }
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: context.read<ReimbursementBloc>(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(modalContext),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      builder: (context, state) {
                        return Text(
                          '✓ ${state.category}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(modalContext),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF007BFF),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: ReimbursementBloc.categories.length,
                  itemBuilder: (context, index) {
                    final category = ReimbursementBloc.categories[index];
                    return BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      builder: (context, state) {
                        return ListTile(
                          title: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: state.category == category
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF007BFF),
                                )
                              : null,
                          onTap: () {
                            context.read<ReimbursementBloc>().add(
                              UpdateCategoryEvent(category),
                            );
                            Navigator.pop(modalContext);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreviewSection(BuildContext context, List<File> files) {
    return Column(
      children: [
        // File navigation section
        Container(
          height: 60,
          child: Row(
            children: [
              // Left arrow
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: files.length > 1
                      ? () {
                          if (_selectedImageIndex > 0) {
                            setState(() {
                              _selectedImageIndex--;
                            });
                            _pageController.animateToPage(
                              _selectedImageIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      : null,
                  icon: Icon(
                    Icons.chevron_left,
                    color: files.length > 1 && _selectedImageIndex > 0
                        ? Colors.black54
                        : Colors.grey[400],
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(width: 12),

              // File tab
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007BFF).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFF007BFF),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                _getFileName(files[_selectedImageIndex]),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _getFileExtension(files[_selectedImageIndex]),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Delete button
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            final fileToRemove = files[_selectedImageIndex];
                            context.read<ReimbursementBloc>().add(
                              RemoveFileEvent(fileToRemove),
                            );

                            // Adjust selected index if necessary
                            if (_selectedImageIndex >= files.length - 1 &&
                                files.length > 1) {
                              setState(() {
                                _selectedImageIndex = files.length - 2;
                              });
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Right arrow
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: files.length > 1
                      ? () {
                          if (_selectedImageIndex < files.length - 1) {
                            setState(() {
                              _selectedImageIndex++;
                            });
                            _pageController.animateToPage(
                              _selectedImageIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      : null,
                  icon: Icon(
                    Icons.chevron_right,
                    color:
                        files.length > 1 &&
                            _selectedImageIndex < files.length - 1
                        ? Colors.black54
                        : Colors.grey[400],
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Image preview with PageView
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              itemCount: files.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedImageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildImagePreview(files[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getFileName(File file) {
    final fileName = file.path.split('/').last;
    final parts = fileName.split('.');
    if (parts.length > 1) {
      return parts.sublist(0, parts.length - 1).join('.');
    }
    return fileName;
  }

  String _getFileExtension(File file) {
    final fileName = file.path.split('/').last;
    final parts = fileName.split('.');
    if (parts.length > 1) {
      return '.${parts.last}';
    }
    return '';
  }

  // Updated helper method to build image preview
  Widget _buildImagePreview(File file) {
    final extension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Image.file(
        file,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFileIcon(extension);
        },
      );
    } else {
      return _buildFileIcon(extension);
    }
  }

  Widget _buildFileIcon(String extension) {
    IconData iconData;
    Color iconColor;

    switch (extension) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 80, color: iconColor),
          const SizedBox(height: 16),
          Text(
            extension.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Reimbursement Portal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ReimbursementBloc, ReimbursementState>(
        listener: (context, state) {
          if (state.status == ReimbursementStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reimbursement claim submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state.status == ReimbursementStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Submit a New Reimbursement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        // TextButton(
                        //   onPressed: () => Navigator.pop(context),
                        //   child: const Text(
                        //     'Cancel',
                        //     style: TextStyle(
                        //       color: Color(0xFF007BFF),
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description Field
                    const Text(
                      'Reimbursement Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      buildWhen: (previous, current) =>
                          previous.description != current.description,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _descriptionController,
                          onChanged: (value) {
                            context.read<ReimbursementBloc>().add(
                              UpdateDescriptionEvent(value),
                            );
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Type a brief description of the reimbursement.',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF007BFF),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Category Field
                    const Text(
                      'Select the Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      buildWhen: (previous, current) =>
                          previous.category != current.category,
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () => _showCategoryBottomSheet(context),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFE5E5E5),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Service Provider Field
                    const Text(
                      'Service Provider',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      buildWhen: (previous, current) =>
                          previous.provider != current.provider,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _providerController,
                          onChanged: (value) {
                            context.read<ReimbursementBloc>().add(
                              UpdateProviderEvent(value),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Type the provider\'s name...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF007BFF),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Amount and Date Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reimbursement amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<
                                ReimbursementBloc,
                                ReimbursementState
                              >(
                                buildWhen: (previous, current) =>
                                    previous.amount != current.amount,
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: _amountController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      final amount =
                                          double.tryParse(value) ?? 0.0;
                                      context.read<ReimbursementBloc>().add(
                                        UpdateAmountEvent(amount),
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      prefixText: '\$ ',
                                      prefixStyle: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE5E5E5),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE5E5E5),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF007BFF),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date of Purchase',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<
                                ReimbursementBloc,
                                ReimbursementState
                              >(
                                buildWhen: (previous, current) =>
                                    previous.purchaseDate !=
                                    current.purchaseDate,
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFE5E5E5),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        state.purchaseDate != null
                                            ? '${state.purchaseDate!.day}/${state.purchaseDate!.month}/${state.purchaseDate!.year}'
                                            : 'Select Date',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: state.purchaseDate != null
                                              ? Colors.black87
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Additional Notes Field
                    const Text(
                      'Additional Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      buildWhen: (previous, current) =>
                          previous.notes != current.notes,
                      builder: (context, state) {
                        return TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          onChanged: (value) {
                            context.read<ReimbursementBloc>().add(
                              UpdateNotesEvent(value),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Type Additional Notes here...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E5E5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF007BFF),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // File Upload Section
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      buildWhen: (previous, current) =>
                          previous.attachedFiles != current.attachedFiles,
                      builder: (context, state) {
                        // Reset selected index if files change
                        if (_selectedImageIndex >= state.attachedFiles.length) {
                          _selectedImageIndex = 0;
                        }

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  context.read<ReimbursementBloc>().pickFiles(),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF007BFF),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF007BFF,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.cloud_upload_outlined,
                                        size: 32,
                                        color: Color(0xFF007BFF),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Browse your device',
                                      style: TextStyle(
                                        color: Color(0xFF007BFF),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // File Preview Section
                            if (state.attachedFiles.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              _buildFilePreviewSection(
                                context,
                                state.attachedFiles,
                              ),
                            ],
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    BlocBuilder<ReimbursementBloc, ReimbursementState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                state.status == ReimbursementStatus.loading
                                ? null
                                : () {
                                    context.read<ReimbursementBloc>().add(
                                      const SubmitReimbursementEvent(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: state.status == ReimbursementStatus.loading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Submit Reimbursement',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
