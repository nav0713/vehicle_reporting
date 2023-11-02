import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_reporting/bloc/vehicles/vehicles_bloc.dart';
import 'package:vehicle_reporting/model/vehicle.dart';
import 'package:vehicle_reporting/security/full_screen_image.dart';
import 'package:vehicle_reporting/style.dart';

class ViewVehicleDetailsScreen extends StatefulWidget {
  const ViewVehicleDetailsScreen({super.key});

  @override
  State<ViewVehicleDetailsScreen> createState() =>
      _ViewVehicleDetailsScreenState();
}

class _ViewVehicleDetailsScreenState extends State<ViewVehicleDetailsScreen> {
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final ImagePicker imagePicker = ImagePicker();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  final formkey = GlobalKey<FormBuilderState>();
  String? selectedCat;
  final List<String> categories = [
    "Employee Parking",
    "Graduate / Undergraduate",
    "Board of Regent, CSU VIPs",
    "Concenssionaries, Supplier, Service Provider",
    "Drop - OFF"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("vehicle details"),
      ),
      body: BlocConsumer<VehiclesBloc, VehiclesState>(
        listener: (context, state) {
          if (state is VehicleUpdateSuccess) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                        "Update success. Please wait for admin approval!"),
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
          if (state is VehicleViewDetailsState) {
            return SingleChildScrollView(
              child: Container(
                height: 900,
                padding:
                    const EdgeInsets.symmetric(horizontal: 42, vertical: 32),
                child: FormBuilder(
                    key: formkey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                            initialValue: state.vehicle.ownerName,
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
                            initialValue: state.vehicle.ownerId,
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
                            initialValue: state.vehicle.ownerAddress,
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
                            initialValue: state.vehicle.ownerContact,
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
                            initialValue: state.vehicle.applyingFor,
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
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList()),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(children: [
                            Flexible(
                              child: FormBuilderTextField(
                                  initialValue: state.vehicle.type,
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
                                  initialValue: state.vehicle.brand,
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
                                  initialValue: state.vehicle.color,
                                  decoration:
                                      normalTextFieldStyle("Color", "Color"),
                                  name: "color"),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              child: FormBuilderTextField(
                                  initialValue: state.vehicle.plate,
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
                            initialValue: state.vehicle.relationship,
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
                        Expanded(
                          child: imageFileList!.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      itemCount: state.vehicle.images.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return FullScreenImage(
                                                    imageLink: state
                                                        .vehicle.images[index]);
                                              }));
                                            },
                                            child: Image.network(
                                              state.vehicle.images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              : Padding(
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
                        TextButton(
                            onPressed: () {
                              selectImages();
                            },
                            child: const Text("update images")),
                        SizedBox(
                          height: 60,
                          width: 300,
                          child: ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.saveAndValidate()) {
                                  final String name =
                                      formkey.currentState!.value['fullname'];
                                  final String id =
                                      formkey.currentState!.value['id'];
                                  final String address =
                                      formkey.currentState!.value['address'];
                                  final String contact =
                                      formkey.currentState!.value['contact'];
                                  final String type = formkey
                                      .currentState!.value['vehicle_type'];
                                  final String brand =
                                      formkey.currentState!.value['brand'];
                                  final String color =
                                      formkey.currentState!.value['color'];
                                  final String plate =
                                      formkey.currentState!.value['plate'];
                                  final String relationship = formkey
                                      .currentState!.value['relationship'];

                                  Vehicle vehicle = Vehicle(
                                      ownerAddress: address,
                                      ownerContact: contact,
                                      ownerName: name,
                                      applyingFor: selectedCat ??
                                          state.vehicle.applyingFor,
                                      images: imageFileList!.isEmpty
                                          ? state.vehicle.images
                                          : [],
                                      brand: brand,
                                      color: color,
                                      ownerId: id,
                                      plate: plate,
                                      relationship: relationship,
                                      remarks: state.vehicle.remarks,
                                      status: false,
                                      type: type);

                                  context.read<VehiclesBloc>().add(
                                      UpdateVehicle(
                                          images: imageFileList!,
                                          vehicle: vehicle));
                                }
                              },
                              style: mainBtnStyle(Colors.teal,
                                  Colors.transparent, Colors.white),
                              child: const Text("Update")),
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
    );
  }
}
