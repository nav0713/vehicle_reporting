import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_reporting/bloc/vehicles/vehicles_bloc.dart';
import 'package:vehicle_reporting/model/vehicle.dart';
import 'package:vehicle_reporting/vehicles/add_vehicle.dart';
import 'package:vehicle_reporting/vehicles/view_vehicle.dart';

class MyVehicle extends StatelessWidget {
  const MyVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VehiclesBloc>(context);
    int index = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Vehicles"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return BlocProvider<VehiclesBloc>.value(
                    value: VehiclesBloc()..add(ShowAddVehicleForm()),
                    child: AddVehicleScreen(
                      bloc: bloc,
                    ),
                  );
                }));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: BlocConsumer<VehiclesBloc, VehiclesState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is VehicleLoadedState) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("registered_vehicle")
                    .where("owner_id", isEqualTo: state.ownerId)
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("No Registered Vehicle"),
                    );
                  }

                  return DataTable2(
                      columnSpacing: 8,
                      minWidth: 900,
                      columns: const [
                        DataColumn2(
                          fixedWidth: 50,
                          label: Text("No."),
                        ),
                        DataColumn2(
                          fixedWidth: 130,
                          label: Text("Plate Number"),
                        ),
                        DataColumn2(fixedWidth: 100, label: Text("Brand")),
                        DataColumn2(fixedWidth: 100, label: Text("Type")),
                        DataColumn2(fixedWidth: 100, label: Text("Color")),
                        DataColumn2(
                            fixedWidth: 150, label: Text("Approval Status")),
                        DataColumn2(fixedWidth: 100, label: Text("Remarks")),
                        DataColumn2(fixedWidth: 60, label: Text("details"))
                      ],
                      rows: snapshot.data!.docs.map((e) {
                        index++;
                        return DataRow(cells: [
                          DataCell(
                            Text(index.toString()),
                          ),
                          DataCell(
                            Text(e.get('plate')),
                          ),
                          DataCell(
                            Text(e.get('brand')),
                          ),
                          DataCell(
                            Text(e.get('vehicle_type')),
                          ),
                          DataCell(
                            Text(e.get('color')),
                          ),
                          DataCell(
                            Text(
                              e.get('status') ? "Approved" : "Not Approve",
                              style: TextStyle(
                                  color: e.get('status')
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          DataCell(
                            Text(
                              e.get('remarks') == ""
                                  ? "ongoing review"
                                  : e.get('remarks'),
                              style: TextStyle(
                                  color: e.get('status')
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                List<String> images = [];
                                final files = e.get('images');
                                for (var img in files) {
                                  images.add(img);
                                }
                                Vehicle vehicle = Vehicle(
                                    ownerAddress: e.get("owner_address"),
                                    ownerContact: e.get("owner_contact"),
                                    ownerName: e.get("owner_name"),
                                    ownerId: e.get("owner_id"),
                                    applyingFor: e.get("applying_for"),
                                    images: images,
                                    brand: e.get("brand"),
                                    color: e.get("color"),
                                    plate: e.get("plate"),
                                    relationship: e.get("relationship"),
                                    remarks: e.get("remarks"),
                                    status: e.get("status"),
                                    type: e.get("vehicle_type"));

                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return BlocProvider<VehiclesBloc>.value(
                                    value: VehiclesBloc()
                                      ..add(
                                          ViewVehicleDetails(vehicle: vehicle)),
                                    child: const ViewVehicleDetailsScreen(),
                                  );
                                }));
                              },
                              child: const Text(
                                "View",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                        ]);
                      }).toList());
                }));
          }

          return Container();
        },
      ),
    );
  }
}
