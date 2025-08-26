import 'package:aetna_app/features/card_replacement/presentation/pages/update_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/card_replacement_bloc.dart';
import '../bloc/card_replacement_event.dart';
import '../bloc/card_replacement_state.dart';
import 'acknowledgment_screen.dart';

class CardReplacementScreen extends StatelessWidget {
  const CardReplacementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardReplacementBloc(),
      child: const CardReplacementScreenView(),
    );
  }
}

class CardReplacementScreenView extends StatefulWidget {
  const CardReplacementScreenView({Key? key}) : super(key: key);

  @override
  State<CardReplacementScreenView> createState() =>
      _CardReplacementScreenViewState();
}

class _CardReplacementScreenViewState extends State<CardReplacementScreenView> {
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _streetLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _streetController.dispose();
    _streetLine2Controller.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _showReasonBottomSheet() {
    final bloc = context.read<CardReplacementBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: bloc,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
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
                    BlocBuilder<CardReplacementBloc, CardReplacementState>(
                      builder: (context, state) {
                        return Text(
                          state.reason.isEmpty
                              ? 'Select...'
                              : '✓ ${state.reason}',
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
                  itemCount: CardReplacementBloc.reasons.length,
                  itemBuilder: (context, index) {
                    final reason = CardReplacementBloc.reasons[index];
                    return BlocBuilder<
                      CardReplacementBloc,
                      CardReplacementState
                    >(
                      builder: (context, state) {
                        return ListTile(
                          title: Text(
                            reason,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: state.reason == reason
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF007BFF),
                                )
                              : null,
                          onTap: () {
                            context.read<CardReplacementBloc>().add(
                              UpdateReasonEvent(reason),
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

  void _showStateBottomSheet() {
    final bloc = context.read<CardReplacementBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: bloc,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
                    BlocBuilder<CardReplacementBloc, CardReplacementState>(
                      builder: (context, state) {
                        return Text(
                          state.state.isEmpty
                              ? 'Select State'
                              : '✓ ${state.state}',
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
                  itemCount: CardReplacementBloc.usStates.length,
                  itemBuilder: (context, index) {
                    final stateName = CardReplacementBloc.usStates[index];
                    return BlocBuilder<
                      CardReplacementBloc,
                      CardReplacementState
                    >(
                      builder: (context, state) {
                        return ListTile(
                          title: Text(
                            stateName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: state.state == stateName
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF007BFF),
                                )
                              : null,
                          onTap: () {
                            context.read<CardReplacementBloc>().add(
                              UpdateStateEvent(stateName),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CardReplacementBloc, CardReplacementState>(
      listener: (context, state) {
        if (state.status == CardReplacementStatus.showingAcknowledgment) {
          final bloc = context.read<CardReplacementBloc>(); // capture here

          if (state.status == CardReplacementStatus.showingAcknowledgment) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: bloc, // pass the same instance
                  child: const AcknowledgmentScreen(),
                ),
              ),
            );
          }
        } else if (state.status == CardReplacementStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Card replacement request submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state.status == CardReplacementStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
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
              'Request a Replacement Card',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reason for Request
                const Text(
                  'Reason for Request*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showReasonBottomSheet,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: state.reason.isEmpty
                            ? const Color(0xFF007BFF)
                            : const Color(0xFFE5E5E5),
                        width: state.reason.isEmpty ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            state.reason.isEmpty ? 'Select...' : state.reason,
                            style: TextStyle(
                              fontSize: 16,
                              color: state.reason.isEmpty
                                  ? Colors.grey[600]
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Phone Number
                const Text(
                  'Phone Number*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (value) {
                    BlocProvider.of<CardReplacementBloc>(
                      context,
                    ).add(UpdatePhoneNumberEvent(value));
                  },
                  decoration: InputDecoration(
                    hintText: '###-###-####',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF007BFF),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 32),

                // Mailing Address Section
                const Text(
                  'Mailing Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The card listed below is confirmed to be mailed to your current address. If this address is not correct, please use the \'Update Address\' to contact your benefits administrator to change your address.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 24),

                // Street Address
                const Text(
                  'Street',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _streetController,
                  onChanged: (value) {
                    BlocProvider.of<CardReplacementBloc>(
                      context,
                    ).add(UpdateStreetEvent(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter street address',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF007BFF),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 20),

                // Street Line 2
                const Text(
                  'Street Line 2',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _streetLine2Controller,
                  onChanged: (value) {
                    BlocProvider.of<CardReplacementBloc>(
                      context,
                    ).add(UpdateStreetLine2Event(value));
                  },
                  decoration: InputDecoration(
                    hintText: 'Apt, suite, etc. (optional)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF007BFF),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 20),

                // City, State, Zip Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'City',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _cityController,
                            onChanged: (value) {
                              BlocProvider.of<CardReplacementBloc>(
                                context,
                              ).add(UpdateCityEvent(value));
                            },
                            decoration: InputDecoration(
                              hintText: 'City',
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
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // State
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'State*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _showStateBottomSheet,
                            child: Container(
                              width: double.infinity,
                              height: 56, // Fixed height to match TextFormField
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      state.state.isEmpty
                                          ? 'State'
                                          : state.state,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: state.state.isEmpty
                                            ? Colors.grey[400]
                                            : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Zip Code
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Zip Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _zipCodeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                            onChanged: (value) {
                              BlocProvider.of<CardReplacementBloc>(
                                context,
                              ).add(UpdateZipCodeEvent(value));
                            },
                            decoration: InputDecoration(
                              hintText: 'Zip',
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
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Update Address Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateAddressScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF007BFF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Update Address',
                      style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Submit Request Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.status == CardReplacementStatus.loading
                        ? null
                        : () {
                            BlocProvider.of<CardReplacementBloc>(
                              context,
                            ).add(const SubmitCardRequestEvent());
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isFormValid
                          ? const Color(0xFF007BFF)
                          : const Color(0xFFE5E5E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.status == CardReplacementStatus.loading)
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                state.isFormValid ? Colors.white : Colors.grey,
                              ),
                            ),
                          )
                        else ...[
                          Text(
                            'Submit Request',
                            style: TextStyle(
                              color: state.isFormValid
                                  ? Colors.white
                                  : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: state.isFormValid
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
