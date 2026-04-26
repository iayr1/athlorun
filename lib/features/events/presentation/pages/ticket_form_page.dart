import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/config/styles/app_colors.dart';
import 'package:athlorun/config/styles/app_textstyles.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/windows.dart';
import 'package:athlorun/core/widgets/custom_action_button.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/events/data/models/response/get_events_response_model.dart';
import 'package:athlorun/features/events/presentation/bloc/events_page_cubit.dart';
import '../../../profile/presentation/widgets/custom_drop_down_widget.dart';

class TicketFormPageWrapper extends StatelessWidget {
  final GetEventsResponseModelData getEventsResponseModelData;
  final int selectedTicketQuantity;
  final Slot? slot;
  final double? amount;

  const TicketFormPageWrapper({
    super.key,
    required this.getEventsResponseModelData,
    required this.selectedTicketQuantity,
    this.slot,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EventsPageCubit>(),
      child: TicketFormPage(
        getEventsResponseModelData: getEventsResponseModelData,
        selectedTicketQuantity: selectedTicketQuantity,
        slot: slot,
        amount: amount!,
      ),
    );
  }
}

class TicketFormPage extends StatefulWidget {
  final GetEventsResponseModelData getEventsResponseModelData;
  final int selectedTicketQuantity;
  final Slot? slot;
  final double? amount;

  const TicketFormPage({
    super.key,
    required this.getEventsResponseModelData,
    required this.selectedTicketQuantity,
    this.slot,
    this.amount,
  });

  @override
  State<TicketFormPage> createState() => _TicketFormPageState();
}

class _TicketFormPageState extends State<TicketFormPage> {
  late EventsPageCubit _eventsPageCubit;

  @override
  void initState() {
    _eventsPageCubit = context.read<EventsPageCubit>();
    _eventsPageCubit.generateForms(widget.selectedTicketQuantity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsPageCubit, EventsPageState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.neutral10,
          appBar: customAppBar(
            title: AppStrings.ticketHolderDetails,
            centerTitle: true,
            onBackPressed: () => Navigator.pop(context),
          ),
          body: ListView.builder(
            itemCount: _eventsPageCubit.getTicketHolders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TicketHolderCard(index: index),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: Window.getPadding(all: 16),
            child: BlocBuilder<EventsPageCubit, EventsPageState>(
              builder: (context, state) {
                return CustomActionButton(
                  name: AppStrings.continueTxt,
                  isFormFilled: _eventsPageCubit.getisFormFilled,
                  onTap: (startLoading, stopLoading, btnState) {
                    _eventsPageCubit.submitForm(
                      context,
                      widget.getEventsResponseModelData,
                      widget.slot,
                      widget.amount!,
                      widget.selectedTicketQuantity,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class TicketHolderCard extends StatelessWidget {
  final int index;

  const TicketHolderCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsPageCubit, EventsPageState>(
      builder: (context, state) {
        List<String> genderList = ['Male', 'Female'];
        final cubit = context.read<EventsPageCubit>();
        final ticketHolder = cubit.getTicketHolders[index];
        final nameController = cubit.getNameControllers[index];
        final ageController = cubit.getAgeControllers[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: Window.getPadding(all: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.neutral10,
            border: Border.all(color: AppColors.neutral30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ticket ${index + 1}', style: AppTextStyles.subtitleMedium),
              const SizedBox(height: 12),

              /// Name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.neutral50),
                  filled: true,
                  fillColor: AppColors.neutral20,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) {
                  cubit.updateTicketHolder(index);
                },
              ),
              SizedBox(height: Window.getVerticalSize(12)),

              /// Age
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Age",
                  hintStyle: AppTextStyles.bodyRegular
                      .copyWith(color: AppColors.neutral50),
                  filled: true,
                  fillColor: AppColors.neutral20,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) {
                  cubit.updateTicketHolder(index);
                },
              ),
              SizedBox(height: Window.getVerticalSize(10)),

              /// Gender Dropdown
              CustomDropDownWidget(
                bottomTitle: "Gender",
                value: ticketHolder.gender,
                items: genderList,
                getLabel: (gender) => gender,
                iconBuilder: (gender) {
                  return Icon(
                    gender == 'Male' ? Icons.male : Icons.female,
                    size: 24,
                    color: gender == 'Male' ? Colors.blue : Colors.pink,
                  );
                },
                onChanged: (value) {
                  if (value != null) {
                    cubit.getTicketHolders[index].gender = value;
                    cubit.updateTicketHolder(index);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
