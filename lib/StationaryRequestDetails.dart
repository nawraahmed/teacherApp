import 'package:flutter/material.dart';

import 'Services/APIListRequests.dart';

class StationaryRequestDetailsPage extends StatelessWidget {
  final StationaryRequest stationaryRequest;

  StationaryRequestDetailsPage({required this.stationaryRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stationary Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request ID: ${stationaryRequest.id}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Status: ${stationaryRequest.statusName}'),
            Text('Requested Quantity: ${stationaryRequest.requestedQuantity}'),
            Text('Notes: ${stationaryRequest.notes}'),
            Text('For class: ${stationaryRequest.classId}'),

            // Add additional widgets and information based on your needs
          ],
        ),
      ),
    );
  }
}
