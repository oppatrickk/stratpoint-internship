import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stratpoint_internship/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  const CriticalFailureDisplay({Key? key, required this.failure}) : super(key: key);

  final NoteFailure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('😱', style: TextStyle(fontSize: 100)),
          const SizedBox(height: 8.0),
          Text(
            failure.maybeMap(insufficientPermission: (_) => 'Insufficient Permissions', orElse: () => 'Unexpected Error! \n Please contact support'),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Icon(Icons.mail),
                SizedBox(width: 8.0),
                Text('SEND EMAIL'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
