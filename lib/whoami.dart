import 'package:flutter/material.dart';

class whoam extends StatelessWidget {
  const whoam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(221, 0, 0, 0),
      ),
      body: Container(
        color: Color.fromARGB(255, 202, 213, 223),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: 147,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Text(
                    ' Bahaa Assi',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: 220,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Row(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  Text(
                    ' bahaaox@gmail.com',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              width: 260,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Row(
                children: [
                  Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                  Text(
                    ' Student at Birzeit University',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
