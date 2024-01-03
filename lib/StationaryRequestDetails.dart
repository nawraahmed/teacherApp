import 'package:flutter/material.dart';

import 'Services/APIListRequests.dart';
import 'main.dart';

class StationaryRequestDetailsPage extends StatelessWidget {
  final StationaryRequest stationaryRequest;

  StationaryRequestDetailsPage({required this.stationaryRequest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stationary Request Details'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Adjust the width as needed
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Styles.primaryNavy, // Use your primaryNavy color
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0,),
              Text(
                'Status: ${stationaryRequest.statusName}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              const SizedBox(height: 20.0,),
              Text('Requested Quantity: ${stationaryRequest.requestedQuantity}', style: TextStyle(color: Colors.white)),
              Text('Notes: ${stationaryRequest.notes}', style: TextStyle(color: Colors.white)),
              Text('For class: ${stationaryRequest.classId}', style: TextStyle(color: Colors.white)),

              // Add additional widgets and information based on your needs

              // TODO: add stationairy item
              // TODO: class name (pass it)
            ],
          ),
        ),
      ),
    );
  }
}
