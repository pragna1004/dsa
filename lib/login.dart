import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(mee());
}

class mee extends StatefulWidget {
  const mee({super.key});

  @override
  State<mee> createState() => _meeState();
}

class _meeState extends State<mee> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
        
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.blue.shade900,Colors.black,Colors.blue.shade600],
              radius: 1.28,
              center: AlignmentGeometry.directional(-1, -1)
        
        
        
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    BackButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height:100,
                ),
                Text("H i  T h e r e !",style: GoogleFonts.ebGaramond(
                  fontSize: 30,

                  color: Colors.white,
                ),),
                SizedBox(
                  height:100,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,10,0),
                  child: Container(
                    height: 40,
                    width:double.infinity,
                    decoration:BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(100),
                      border:Border.all(
                        color:Colors.white54,
                      )

                    ) ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,3),
                      child: TextField(
                        decoration: InputDecoration(
                         border: InputBorder.none,

                         prefixIcon: Icon(Icons.email_outlined),
                          hintText: "Enter your Email id"
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height:20,
                ),
                Row(
                  children: [
                    Container(

                    )

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,10,0),
                  child: Container(
                    height: 40,
                    width:double.infinity,
                    decoration:BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(100),
                        border:Border.all(
                          color:Colors.white54,
                        )

                    ) ,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,3),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,

                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: "Enter your Email id"
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
