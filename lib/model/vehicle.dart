class Vehicle {
  final String applyingFor;
  final String brand;
  final List<String> images;
  final String color;
  final String plate;
  final String relationship;
  final String remarks;
  final bool status;
  final String type;
  final String ownerId;
  final String ownerName;
  final String ownerAddress;
  final String ownerContact;

  const Vehicle(
      {required this.ownerAddress,
      required this.ownerContact,
      required this.ownerName,
      required this.ownerId,
      required this.applyingFor,
      required this.images,
      required this.brand,
      required this.color,
      required this.plate,
      required this.relationship,
      required this.remarks,
      required this.status,
      required this.type});
}
