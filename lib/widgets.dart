// button_widgets.dart

import 'package:flutter/material.dart';

class ButtonWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                
                ElevatedButton(
                  onPressed: () {},
                  
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 91, 109, 223),
                  padding: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                  child: ListTile(
                    leading: Icon(Icons.chat_bubble, color: Colors.white),
                    title: Text('Contact a doctor', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 76, 67, 212),
                  padding: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                  child: ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.white),
                    title: Text('Make an appointment', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                  padding: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                  child: ListTile(
                    leading: Icon(Icons.local_hospital, color: Colors.white),
                    title: Text('Emergency', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
