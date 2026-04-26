import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:athlorun/config/di/dependency_injection.dart';
import 'package:athlorun/core/utils/app_strings.dart';
import 'package:athlorun/core/utils/utils.dart';
import 'package:athlorun/core/widgets/custom_appbar.dart';
import 'package:athlorun/features/profile/data/models/get_gear_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_gear_types_response_model.dart';
import 'package:athlorun/features/profile/data/models/get_sports_response_model.dart';
import 'package:athlorun/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:athlorun/features/profile/presentation/widgets/custom_drop_down_widget.dart';
import 'package:athlorun/features/profile/presentation/widgets/show_image_source_dialog.dart';
import '../../../../config/styles/app_colors.dart';
import '../../../../config/styles/app_textstyles.dart';
import '../../../../core/utils/windows.dart';
import '../../../../core/widgets/custom_action_button.dart';

class AddNewGearWrapper extends StatelessWidget {
  final GetGearResponseModelData? geardata;
  const AddNewGearWrapper({super.key, this.geardata});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: AddGearScreen(gearItem: geardata),
    );
  }
}

class AddGearScreen extends StatefulWidget {
  final GetGearResponseModelData? gearItem;
  const AddGearScreen({super.key, this.gearItem});

  @override
  State<AddGearScreen> createState() => _AddGearScreenState();
}

class _AddGearScreenState extends State<AddGearScreen> {
  final _formKey = GlobalKey<FormState>();
  late final ProfileCubit _cubit;
  Datum? _selectedGearType;
  dynamic gearImage;
  Sport? _selectedDefaultSport;
  String _brand = "";
  String _model = "";
  String _weight = "";
  String authId = "";

  late List<Datum> _gearTypes = [];
  late List<Sport> _defaultSports = [];

  bool get _isFormFilled =>
      _selectedGearType != null &&
      _selectedDefaultSport != null &&
      _brand.isNotEmpty &&
      _model.isNotEmpty &&
      _weight.isNotEmpty &&
      gearImage != null;

  void _saveGear() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.gearItem == null) {
        _cubit
            .createGear(
                authId,
                _selectedGearType!.id.toString(),
                _selectedDefaultSport!.id.toString(),
                _brand,
                _model,
                _weight,
                gearImage!)
            .then((r) {
          Navigator.pop(context);
        }).onError((error, stackTrace) {
          Utils.showCustomDialog(context, AppStrings.error, error.toString());
        });
      } else {
        _cubit.updateGear(
            authId,
            widget.gearItem!.id!,
            _selectedGearType!.id.toString(),
            _selectedDefaultSport!.id.toString(),
            _brand,
            _model,
            _weight,
            gearImage!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ProfileCubit>();
    _cubit.getGearTypes();
    _cubit.getSports();
    _cubit.getAuthData();

    // Pre-populate fields if editing an existing gear
    if (widget.gearItem != null) {
      _brand = widget.gearItem!.brand ?? "";
      _model = widget.gearItem!.model ?? "";
      _weight = widget.gearItem!.weight ?? "";

      // Load image from URL if available
      if (widget.gearItem!.photo != null &&
          widget.gearItem!.photo!.isNotEmpty) {
        gearImage = widget
            .gearItem!.photo!; // Assuming the image URL is converted to File.
      }

      // Set selected sport and gear type only after lists are populated
      if (_defaultSports.isNotEmpty) {
        _selectedDefaultSport = _defaultSports.firstWhere(
          (sport) => sport.id == widget.gearItem!.sport?.id,
          orElse: () => _defaultSports.first,
        );
      }

      if (_gearTypes.isNotEmpty) {
        _selectedGearType = _gearTypes.firstWhere(
          (gear) => gear.id == widget.gearItem!.type?.id,
          orElse: () => _gearTypes.first,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: AppStrings.addNewGear,
        centerTitle: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body:
          BlocConsumer<ProfileCubit, ProfileState>(listener: (context, state) {
        state.maybeWhen(
            loadedGearTypes: (data) {
              _gearTypes = data.data ?? [];
              if (widget.gearItem == null && _gearTypes.isNotEmpty) {
                setState(() {
                  _selectedGearType = _gearTypes.first;
                });
              } else if (widget.gearItem != null &&
                  widget.gearItem!.type != null) {
                _selectedGearType = _gearTypes.firstWhere(
                  (gear) => gear.id == widget.gearItem!.type?.id,
                  orElse: () => _gearTypes.first,
                );
              }
            },
            loadedSports: (data) {
              _defaultSports = data.data ?? [];
              if (widget.gearItem == null && _defaultSports.isNotEmpty) {
                setState(() {
                  _selectedDefaultSport = _defaultSports.first;
                });
              } else if (widget.gearItem != null &&
                  widget.gearItem!.sport != null) {
                _selectedDefaultSport = _defaultSports.firstWhere(
                  (sport) => sport.id == widget.gearItem!.sport?.id,
                  orElse: () => _defaultSports.first,
                );
              }
            },
            pickingImage: () {},
            pickedImage: (image) {
              gearImage = image;
            },
            pickedImageError: (error) {
              Utils.showCustomDialog(context, AppStrings.error, error);
            },
            gettingAuthData: () {},
            gotAuthData: (authData) {
              authId = authData.id;
            },
            orElse: () {});
      }, builder: (context, snapshot) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: Window.getSymmetricPadding(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: Window.getVerticalSize(20)),
                                  CustomDropDownWidget<Datum>(
                                    bottomTitle: AppStrings.gearType,
                                    label: AppStrings.gearType,
                                    value: _selectedGearType,
                                    items: _gearTypes,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGearType = value;
                                      });
                                    },
                                    getLabel: (gear) => gear.name.toString(),
                                    iconBuilder: (gear) => Image.network(
                                      gear.icon ?? '',
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.sports,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Window.getVerticalSize(16)),
                                  CustomDropDownWidget<Sport>(
                                    bottomTitle: AppStrings.defaultSport,
                                    label: AppStrings.defaultSport,
                                    value: _selectedDefaultSport,
                                    items: _defaultSports,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDefaultSport = value;
                                      });
                                    },
                                    getLabel: (sport) => sport.name.toString(),
                                    iconBuilder: (sport) => SvgPicture.network(
                                      sport.icon ?? '',
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.sports,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Window.getVerticalSize(16)),
                                  Utils.buildTextField(
                                    label: "Brand",
                                    hintlabel: "Brand Name",
                                    initialValue: _brand,
                                    onChanged: (value) =>
                                        setState(() => _brand = value),
                                    onSaved: (value) => _brand = value!,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter the brand"
                                            : null,
                                  ),
                                  SizedBox(height: Window.getVerticalSize(16)),
                                  Utils.buildTextField(
                                    label: "Model",
                                    hintlabel: "Model Name",
                                    initialValue: _model,
                                    onChanged: (value) =>
                                        setState(() => _model = value),
                                    onSaved: (value) => _model = value!,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter the model"
                                            : null,
                                  ),
                                  SizedBox(height: Window.getVerticalSize(16)),
                                  Utils.buildTextField(
                                    label: "Weight",
                                    hintlabel: "Weight Name",
                                    initialValue: _weight,
                                    onChanged: (value) =>
                                        setState(() => _weight = value),
                                    onSaved: (value) => _weight = value!,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? "Please enter the weight"
                                            : null,
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(height: Window.getVerticalSize(24)),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ShowImageSourceDialog(
                                              onPickImage:
                                                  (ImageSource source) {
                                                _cubit.pickPanImage(source);
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: Window.width,
                                        height: 180,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                              12), // Rounded corners
                                        ),
                                        child: gearImage != null
                                            ? gearImage is File
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Image.file(
                                                      gearImage!,
                                                      fit: BoxFit.cover,
                                                      width: Window.width,
                                                      height: 180,
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: CachedNetworkImage(
                                                      imageUrl: gearImage,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: AppColors
                                                              .neutral20,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child:
                                                            const CircularProgressIndicator(
                                                                strokeWidth: 2),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: AppColors
                                                              .neutral20,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                            size: 24),
                                                      ),
                                                    ),
                                                  )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    "Gear Image",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: Window.getPadding(all: 16.0),
                      child: CustomActionButton(
                        name: AppStrings.saveGear,
                        isFormFilled: _isFormFilled,
                        onTap: (startLoading, stopLoading, btnState) =>
                            _saveGear(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
