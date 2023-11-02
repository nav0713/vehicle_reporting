import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_reporting/bloc/vehicles/vehicles_bloc.dart';
import 'package:vehicle_reporting/model/owner.dart';
import 'package:vehicle_reporting/style.dart';

import '../model/vehicle.dart';

class AddVehicleScreen extends StatefulWidget {
  final VehiclesBloc bloc;
  const AddVehicleScreen({super.key, required this.bloc});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  List<XFile>? imageFileList = [];
  final formKey = GlobalKey<FormBuilderState>();
  String? selectedCat;
  void selectImages() async {
    final ImagePicker imagePicker = ImagePicker();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "Employee Parking",
      "Graduate / Undergraduate",
      "Board of Regent, CSU VIPs",
      "Concenssionaries, Supplier, Service Provider",
      "Drop - OFF"
    ];
    return WillPopScope(
      onWillPop: () async {
        // widget.bloc.add(LoadMyVehicles());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Add new vehicle")),
        body: BlocConsumer<VehiclesBloc, VehiclesState>(
          listener: (context, state) {
            if (state is VehicleAddSuccess) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                          "Add success. Please wait for admin approval!"),
                      content: TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  });
            }
          },
          builder: (context, state) {
            if (state is VehicleAddingState) {
              return SingleChildScrollView(
                child: Container(
                  height: 900,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 42, vertical: 32),
                  child: FormBuilder(
                      key: formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                              validator: ((value) {
                                if (value == null) {
                                  return "required";
                                }
                                return null;
                              }),
                              decoration:
                                  normalTextFieldStyle("Fullname", "Fullname"),
                              name: "fullname"),
                          const SizedBox(
                            height: 12,
                          ),
                          FormBuilderTextField(
                              validator: ((value) {
                                if (value == null) {
                                  return "required";
                                }
                                return null;
                              }),
                              decoration: normalTextFieldStyle("ID", "ID"),
                              name: "id"),
                          const SizedBox(
                            height: 12,
                          ),
                          FormBuilderTextField(
                              validator: ((value) {
                                if (value == null) {
                                  return "required";
                                }
                                return null;
                              }),
                              decoration:
                                  normalTextFieldStyle("address", "address"),
                              name: "address"),
                          const SizedBox(
                            height: 12,
                          ),
                          FormBuilderTextField(
                              validator: ((value) {
                                if (value == null) {
                                  return "required";
                                }
                                return null;
                              }),
                              decoration: normalTextFieldStyle(
                                  "Contact number", "Contact nUmber"),
                              name: "contact"),
                          const SizedBox(
                            height: 12,
                          ),
                          FormBuilderDropdown(
                              validator: ((value) {
                                if (value == null) {
                                  return "required";
                                }
                                return null;
                              }),
                              decoration: normalTextFieldStyle(
                                  "I am Applying for", "I am Applying for"),
                              name: "categories",
                              onChanged: (cat) {
                                selectedCat = cat;
                              },
                              items: categories.map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList()),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(children: [
                              Flexible(
                                child: FormBuilderTextField(
                                    validator: ((value) {
                                      if (value == null) {
                                        return "required";
                                      }
                                      return null;
                                    }),
                                    decoration: normalTextFieldStyle(
                                        "Vehicle type", "Vehicle type"),
                                    name: "vehicle_type"),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: FormBuilderTextField(
                                    validator: ((value) {
                                      if (value == null) {
                                        return "required";
                                      }
                                      return null;
                                    }),
                                    decoration: normalTextFieldStyle(
                                        "Make/Brand", "Make/Brand"),
                                    name: "brand"),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(children: [
                              Flexible(
                                child: FormBuilderTextField(
                                    decoration:
                                        normalTextFieldStyle("Color", "Color"),
                                    name: "color"),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: FormBuilderTextField(
                                    decoration: normalTextFieldStyle(
                                        "Plate number", "Plate number"),
                                    name: "plate"),
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                              "If the vehicle is not registered under your name, please state relationship to registered name"),
                          const SizedBox(
                            height: 5,
                          ),
                          FormBuilderTextField(
                              decoration: normalTextFieldStyle(
                                  "relationship", "relationship"),
                              name: "relationship"),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "[Please Attached photocopy of the latest Motor Vehicles Registration papers OR/CR, 2x2 Picture and Driver License]",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                selectImages();
                              },
                              child: const Text("Select Images")),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  itemCount: imageFileList!.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(imageFileList![index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 300,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.saveAndValidate() &&
                                      imageFileList!.isNotEmpty) {
                                    final String name =
                                        formKey.currentState!.value['fullname'];
                                    final String id =
                                        formKey.currentState!.value['id'];
                                    final String address =
                                        formKey.currentState!.value['address'];
                                    final String contact =
                                        formKey.currentState!.value['contact'];
                                    final String type = formKey
                                        .currentState!.value['vehicle_type'];
                                    final String brand =
                                        formKey.currentState!.value['brand'];
                                    final String color =
                                        formKey.currentState!.value['color'];
                                    final String plate =
                                        formKey.currentState!.value['plate'];
                                    final String relationship = formKey
                                        .currentState!.value['relationship'];

                                    Vehicle vehicle = Vehicle(
                                        ownerAddress: address,
                                        ownerContact: contact,
                                        ownerName: name,
                                        applyingFor: selectedCat!,
                                        images: [],
                                        brand: brand,
                                        color: color,
                                        ownerId: id,
                                        plate: plate,
                                        relationship: relationship,
                                        remarks: "",
                                        status: false,
                                        type: type);

                                    context.read<VehiclesBloc>().add(AddVehicle(
                                        images: imageFileList!,
                                        vehicle: vehicle));
                                  }
                                },
                                style: mainBtnStyle(Colors.teal,
                                    Colors.transparent, Colors.white),
                                child: const Text("Submit")),
                          )
                        ],
                      )),
                ),
              );
            }
            if (state is VehicleLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (state is VehicleErrorState) {
              return Center(
                child: Column(children: [
                  const Text("Something went Wrong"),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Try Again"))
                ]),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
