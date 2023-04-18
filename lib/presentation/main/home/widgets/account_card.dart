import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/providers/balnace_provider.dart';

import 'package:mccounting_text/mccounting_text.dart';

class AccountCard extends ConsumerWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BalanceProvider balanceProvider = ref.watch(balanceNotifierProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF37CBFA),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            "\$",
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500, fontSize: 40),
                          ),
                          McCountingText(
                            begin: 0,
                            end: balanceProvider.getTotalUsdc(),
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500, fontSize: 40),
                            duration: Duration(seconds: 1),
                            curve: Curves.decelerate,
                            precision: 2,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "+%",
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          McCountingText(
                            begin: 0,
                            end: 7.09,
                            style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w600, fontSize: 14),
                            duration: Duration(seconds: 1),
                            curve: Curves.decelerate,
                            precision: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Account Name",
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Row(
                    children: [
                      Text(
                        "0xjak...akdsj",
                        style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Icon(
                        Icons.copy,
                        size: 15,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Color(0xFF222529),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "View more accounts",
                  style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
