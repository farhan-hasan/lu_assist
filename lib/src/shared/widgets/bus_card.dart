
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/styles/theme/app_theme.dart';

class BusCard extends ConsumerStatefulWidget {
  const BusCard({
    super.key,
  });

  @override
  ConsumerState<BusCard> createState() => _BusCardState();
}

class _BusCardState extends ConsumerState<BusCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/images/DRBUS.png"),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bus number: 4AS23A"),
                SizedBox(height: 5,),
                Text("Bus type: Large"),
                SizedBox(height: 5,),
                outgoingBus()
              ],
            )
          ],
        ),
      ),
    );
  }

  Row incomingBus() {
    return Row(
                children: [
                  Icon(CupertinoIcons.home, color: primaryColor,),
                  Icon(Icons.arrow_right_alt, color: primaryColor,),
                  Icon(Icons.arrow_right_alt, color: primaryColor,),
                  Icon(Icons.arrow_right_alt, color: primaryColor,),
                  Icon(Icons.apartment, color: primaryColor,)
                ],
              );
  }

  Row outgoingBus() {
    return Row(
      children: [
        Icon(Icons.apartment, color: primaryColor,),
        Icon(Icons.arrow_right_alt, color: primaryColor,),
        Icon(Icons.arrow_right_alt, color: primaryColor,),
        Icon(Icons.arrow_right_alt, color: primaryColor,),
        Icon(CupertinoIcons.home, color: primaryColor,)
      ],
    );
  }
}