import 'package:flutter/material.dart';
import 'package:view360/common/theme/app_style.dart';
import 'package:view360/view/bottomNav/bottom_nav.dart';
import '../../../../common/utils/helpers/shared_pref.dart';

class GuestLogin extends StatelessWidget {
  const GuestLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: 100,
      child: InkWell(
        // style: ElevatedButton.styleFrom(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(60),
        //   ),
        //   backgroundColor: Colors.white70,
        //   shadowColor: const Color.fromARGB(0, 73, 71, 71),
        // ),
        onTap: () async {
          //removing token from local storage
          SharedPrefsHelper.remove('token');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        },
        child: Center(child: Icon(Icons.home, color: AppStyle.secondary)),
      ),
    );
  }
}
