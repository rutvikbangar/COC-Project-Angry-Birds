import 'package:chatme/helper/helper_function.dart';
import 'package:chatme/master_page.dart';
import 'package:chatme/pages/auth/loginpage.dart';
import 'package:chatme/pages/finding_people/homepage.dart';
import 'package:chatme/pages/medication/Medication_mainpage.dart';
import 'package:chatme/pages/medication/global_block.dart';
import 'package:chatme/pages/medication/new_entry_bloc.dart';
import 'package:chatme/shared/constant.dart';
import 'package:chatme/widgets/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBlock? globalBlock;
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
    globalBlock=GlobalBlock();
  }
  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value){
      if(value!=null){
        setState(() {
          _isSignedIn = value ;
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBlock>.value(
      value:globalBlock !,
      child: Sizer(builder: (context,orientation,deviceType){
        return MaterialApp(
          theme: ThemeData(

              primaryColor: Constants().primaryColor,
              scaffoldBackgroundColor: Colors.white,
              textTheme:TextTheme(
                headlineMedium: GoogleFonts.aBeeZee(
                    fontSize: 28,fontWeight: FontWeight.bold,
                    color: Constants().textColor),
                displayMedium: GoogleFonts.poppins(fontSize: 28,color: Colors.redAccent),
                displayLarge: GoogleFonts.mulish(fontSize: 20,fontWeight: FontWeight.w500) ,
                labelMedium: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),
                titleSmall: GoogleFonts.poppins(fontSize: 19,fontWeight: FontWeight.w500)


              ),timePickerTheme: TimePickerThemeData(
              backgroundColor: Constants().WhiteishColour,
              hourMinuteColor: Constants().textColor,
              hourMinuteTextColor: Colors.white,
              dayPeriodColor:  Constants().textColor,
              dayPeriodTextColor: Colors.white,
              dialBackgroundColor:  Constants().textColor,
              dialTextColor: Colors.white,
              dialHandColor: Colors.cyan,
              entryModeIconColor: Colors.cyan,
              dayPeriodTextStyle: GoogleFonts.aBeeZee(fontSize: 20)
          )
          ),
          debugShowCheckedModeBanner: false,
          home:_isSignedIn ? MasterPage(): Loginpage(),
          routes: {
            routes.medicationRoute : (context) => MedicationReminder(),

          },

        );

      })
    );

    }
}



