import 'package:flutter/material.dart';

class UserAccountInfoTile extends StatelessWidget {
  const UserAccountInfoTile({super.key, this.dateJoin, this.email});

  final String? email;
  final String? dateJoin;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color(0xFF222529),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Container(
          padding: const EdgeInsets.all(24),
          height: 105,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'xyz121@gmail.com',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text('Joined 12 January 2023',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 13,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1))
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              )
            ],
          ),
        ));
  }
}
