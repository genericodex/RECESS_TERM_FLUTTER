import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/Screens/Views/doctor_details_screen.dart';
import 'package:medical/Screens/Widgets/listicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class find_doctor extends StatelessWidget {
  const find_doctor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("lib/icons/back2.png")),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Column(
          children: [
            Text(
              "Make Appoinment",
              style: GoogleFonts.inter(
                  color: const Color.fromARGB(255, 51, 47, 47),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1),
            ),
          ],
        ),
        toolbarHeight: 130,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(),
              child: TextField(
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.none,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  focusColor: Colors.black26,
                  fillColor: const Color.fromARGB(255, 247, 247, 247),
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: MediaQuery.of(context).size.width * 0.01,
                      child: Image.asset(
                        "lib/icons/search.png",
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  prefixIconColor: const Color.fromARGB(255, 3, 190, 150),
                  label: const Text("Search category"),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Category",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 46, 46, 46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                // CategoryButtonWidget(icon: 'lib/icons/Doctor.png',text: 'General',onPressed: DoctorDetails())
                CategoryButtonWidget(icon: 'lib/icons/Lungs.png',text: 'Surgeon',onPressed: DoctorDetails()),
                CategoryButtonWidget(icon: 'lib/icons/Dentist.png',text: 'Dentist',onPressed: DoctorDetails()),
                CategoryButtonWidget(icon: 'lib/icons/psychology.png',text: 'psychology',onPressed: DoctorDetails()),
              ],
            ),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CategoryButtonWidget(icon: 'lib/icons/covid.png',text: 'consultations',onPressed:DoctorDetails()),
                CategoryButtonWidget(icon: 'lib/icons/injection.png',text: 'physician',onPressed: DoctorDetails()),
                CategoryButtonWidget(icon: 'lib/icons/cardiologist.png',text: 'cardiologist',onPressed: DoctorDetails()),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 25),
          //       child: Text(
          //         "Your Recent Doctors",
          //         style: GoogleFonts.inter(
          //           fontSize: 16.sp,
          //           fontWeight: FontWeight.w700,
          //           color: const Color.fromARGB(255, 46, 46, 46),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   children: [
          //     GestureDetector(
          //        onTap: () {
          //     Navigator.push(
          //         context,
          //         PageTransition(
          //             type: PageTransitionType.rightToLeft,
          //             child: const chat_screen()));
          //   },
          //       child: SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.1400,
          //         width: MediaQuery.of(context).size.width * 0.2900,
          //         child: Column(children: [
          //           Container(
          //             height: MediaQuery.of(context).size.height * 0.100,
          //             width: MediaQuery.of(context).size.width * 0.1900,
          //             decoration: const BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 image: DecorationImage(
          //                     image: AssetImage("lib/icons/male-doctor.png"),
          //                     filterQuality: FilterQuality.high)),
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           const Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [Text("Dr. Marcus")],
          //           )
          //         ]),
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //     Navigator.push(
          //         context,
          //         PageTransition(
          //             type: PageTransitionType.rightToLeft,
          //             child: const chat_screen()));
          //   },
          //       child: SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.1400,
          //         width: MediaQuery.of(context).size.width * 0.2900,
          //         child: Column(children: [
          //           Container(
          //             height: MediaQuery.of(context).size.height * 0.100,
          //             width: MediaQuery.of(context).size.width * 0.1900,
          //             decoration: const BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 image: DecorationImage(
          //                     image: AssetImage("lib/icons/female-doctor.png"),
          //                     filterQuality: FilterQuality.high,
          //                     fit: BoxFit.contain)),
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           const Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [Text("Dr. Maria")],
          //           )
          //         ]),
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //     Navigator.push(
          //         context,
          //         PageTransition(
          //             type: PageTransitionType.rightToLeft,
          //             child: const chat_screen()));
          //   },
          //       child: SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.1400,
          //         width: MediaQuery.of(context).size.width * 0.2900,
          //         child: Column(children: [
          //           Container(
          //             height: MediaQuery.of(context).size.height * 0.100,
          //             width: MediaQuery.of(context).size.width * 0.1900,
          //             decoration: const BoxDecoration(
          //                 shape: BoxShape.circle,
          //                 image: DecorationImage(
          //                     image: AssetImage(
          //                       "lib/icons/black-doctor.png",
          //                     ),
          //                     fit: BoxFit.contain,
          //                     filterQuality: FilterQuality.high)),
          //           ),
          //           const SizedBox(
          //             height: 10,
          //           ),
          //           const Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [Text("Dr. Luke")],
          //           )
          //         ]),
          //       ),
          //     ),
          //   ],
          // ),
        ]),
      ),
    );
  }
}

class CategoryButtonWidget extends StatelessWidget {
  final icon;
  final text;
  final onPressed;

  const CategoryButtonWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0
      ),
      onPressed: () {Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child:  onPressed));}, 
      child: listIcons(Icon: icon, text: text));
  }
}
