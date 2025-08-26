import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../../../reimbursement/presentation/pages/reimbursement_screen.dart';
import '../../../card_replacement/presentation/pages/card_replacement_screen.dart';
import '../widgets/action_card.dart';
import '../widgets/header_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.navigatingToReimbursement) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReimbursementScreen(),
              ),
            ).then((_) {
              // Reset navigation state when returning
              context.read<HomeBloc>().add(const ResetNavigationEvent());
            });
          } else if (state.status == HomeStatus.navigatingToReplacementCard) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CardReplacementScreen(),
              ),
            ).then((_) {
              // Reset navigation state when returning
              context.read<HomeBloc>().add(const ResetNavigationEvent());
            });
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose an action to get started',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Action Cards
                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          return Column(
                            children: [
                              ActionCard(
                                title: 'Submit Reimbursement',
                                subtitle: 'Submit a new reimbursement claim',
                                icon: Icons.receipt_long,
                                color: const Color(0xFF007BFF),
                                isLoading:
                                    state.status ==
                                    HomeStatus.navigatingToReimbursement,
                                onTap: () {
                                  context.read<HomeBloc>().add(
                                    const NavigateToReimbursementEvent(),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              ActionCard(
                                title: 'Request Replacement Card',
                                subtitle: 'Request a new or replacement card',
                                icon: Icons.credit_card,
                                color: const Color(0xFF6B2C91),
                                isLoading:
                                    state.status ==
                                    HomeStatus.navigatingToReplacementCard,
                                onTap: () {
                                  context.read<HomeBloc>().add(
                                    const NavigateToReplacementCardEvent(),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // // Recent Activity Section
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(8),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.05),
                      //         blurRadius: 6,
                      //         offset: const Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Icon(
                      //             Icons.history,
                      //             color: Colors.grey[600],
                      //             size: 16,
                      //           ),
                      //           const SizedBox(width: 6),
                      //           const Text(
                      //             'Recent Activity',
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               color: Colors.black87,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       const SizedBox(height: 12),
                      //       Center(
                      //         child: Column(
                      //           children: [
                      //             Icon(
                      //               Icons.inbox_outlined,
                      //               size: 36,
                      //               color: Colors.grey[400],
                      //             ),
                      //             const SizedBox(height: 8),
                      //             Text(
                      //               'No recent activity',
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 color: Colors.grey[600],
                      //               ),
                      //             ),
                      //             const SizedBox(height: 2),
                      //             Text(
                      //               'Your claims and requests will appear here',
                      //               style: TextStyle(
                      //                 fontSize: 12,
                      //                 color: Colors.grey[500],
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
