import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_reporting/bloc/admin/admin_bloc.dart';

import '../shared/home/home.dart';
import '../style.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateFormat dteFormat2 = DateFormat.yMMMMd('en_US').add_jm();
  Timestamp? filterDate;
  String? affilation;
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormBuilderState>();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Center(
                    child: Row(
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text("A"),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Administrator")
                      ],
                    ),
                  )),
            ),
            ListTile(
              leading: const Icon(FontAwesome5.user),
              title: const Text("View Logs"),
              onTap: () {
                scaffoldKey.currentState!.closeDrawer();
                context.read<AdminBloc>().add(LoadLogs());
              },
            ),
        
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesome.ioxhost),
              title: const Text("Add Vehicle Owner"),
              onTap: () {
                scaffoldKey.currentState!.closeDrawer();
                context.read<AdminBloc>().add(ShowAddUserScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesome5.sign_out_alt),
              title: const Text("Sign Out"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const HomePage();
                }));
                scaffoldKey.currentState!.closeDrawer();
              },
            ),
          ],
        )),
        appBar: AppBar(
          title: const Text("Administrator"),
        ),
        body: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            BuildContext parent = context;
            if (state is OwnderAdded) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Vehicle Added Successfull"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              parent.read<AdminBloc>().add(LoadLogs());
                            },
                            child: const Text("OK"))
                      ],
                    );
                  });
            }
          },
          builder: (context, state) {
            if (state is LogsLoaded) {
              return StreamBuilder<QuerySnapshot>(
                  stream: filterDate == null
                      ? FirebaseFirestore.instance
                          .collection("vehicle_logs")
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("vehicle_logs")
                          .where('datetime', isLessThanOrEqualTo: filterDate)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("Vehicle Logs",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 24),),
                         ),
                        FormBuilderDateTimePicker(
                            decoration: normalTextFieldStyle("Filter", "Filter")
                                .copyWith(
                                    prefixIcon:
                                        const Icon(FontAwesome5.calendar_day)),
                            name: "filter",
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  filterDate = Timestamp.fromDate(value);
                                });
                              }
                            }),
                        Expanded(
                          child: DataTable2(
                              minWidth: 600,
                              columns: const [
                                DataColumn2(
                                    fixedWidth: 100,
                                    label: Text("Plate number")),
                                DataColumn2(label: Text("Owner name")),
                                DataColumn2(label: Text("Affiliation")),
                                DataColumn2(label: Text("Date Time")),
                              ],
                              rows: snapshot.data!.docs.map((e) {
                                var datetime =
                                    (e.get('datetime') as Timestamp).toDate();
                                return DataRow(cells: [
                                  DataCell(Text(e.get('plate_number'))),
                                  DataCell(Text(e.get('owner_name'))),
                                  DataCell(Text(e.get('affiliation'))),
                                  DataCell(Text(dteFormat2.format(datetime)))
                                ]);
                              }).toList()),
                        ),
                      ],
                    );
                  });
            }
            if (state is AddUserFormLoaded) {
              return Column(
                children: [
                   Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("Add Vehicle Owner",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 24),),
                         ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
                    child: Center(
                        child: FormBuilder(
                      key: formKey,
                      child: Column(children: [
                        FormBuilderTextField(
                          textCapitalization: TextCapitalization.characters,
                          decoration:
                              normalTextFieldStyle("Plate Number", "Plate Number"),
                          name: "plate",
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FormBuilderTextField(
                          decoration:
                              normalTextFieldStyle("Owner Name", "Owner Name"),
                          name: "name",
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          decoration: normalTextFieldStyle(
                              "Contact Number", "Contact Number"),
                          name: "contact",
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FormBuilderDropdown(
                          validator: (value) {
                            if (value == null) {
                              return "This field is required";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            affilation = value;
                          },
                          decoration:
                              normalTextFieldStyle("Affiliation", "Affiliation"),
                          name: "affiliation",
                          items: ["Employee", "Student"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: ElevatedButton(
                              style: mainBtnStyle(
                                  Colors.black, Colors.transparent, Colors.white10),
                              onPressed: () {
                                if (formKey.currentState!.saveAndValidate()) {
                                  String plate = formKey
                                      .currentState!.value['plate']
                                      .toString()
                                      .toUpperCase();
                                  String name = formKey.currentState!.value['name'];
                                  String contact =
                                      formKey.currentState!.value['contact'];
                                  String affiliation = affilation!;
                                  context.read<AdminBloc>().add(AddUser(
                                      affiliation: affiliation,
                                      contact: contact,
                                      ownerName: name,
                                      plateNumber: plate));
                                }
                              },
                              child: const Text("Submit")),
                        )
                      ]),
                    )),
                  ),
                ],
              );
            }
            if (state is AdminLoadingState) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            }
            if (state is AdminErrorState) {
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
                        context.read<AdminBloc>().add(LoadLogs());
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
