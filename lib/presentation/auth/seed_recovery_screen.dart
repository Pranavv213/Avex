import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/router.gr.dart';
import '../widget/button.dart';

class SeedRecoveryScreen extends ConsumerWidget {
  const SeedRecoveryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back_ios),
                  Text(
                    "Setup Seedless Recovery",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 24),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child:
                    Text("To backup your wallet complete all the steps below"),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      color: Color(0xFF33BB7A),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8),
                        child: Text(
                          "1 of 3 completed",
                          style: GoogleFonts.inter(
                              fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              for (int i = 0; i < 3; i++)
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Row(children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(Icons.lock),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text("Cloud Key"),
                            subtitle: Text(
                                "Securely store the cloud key on your Google Drive"),
                          ),
                        )
                      ]),
                    )),
              Expanded(child: Container()),
              const SizedBox(
                height: 12,
              ),
              CustomButton(
                onClick: () => {
                  AutoRouter.of(context).push(RestoreExistingAccountRoute())
                },
                title: "Open My Email",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
