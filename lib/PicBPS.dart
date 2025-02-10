import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PicBPSPage extends StatefulWidget{
  const PicBPSPage({super.key});

  @override
  State<PicBPSPage> createState() => _PicBPSState();
}

class _PicBPSState extends State<PicBPSPage>{
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "PIC BPS PAGE", style: TextStyle(fontSize: 30,),textAlign: TextAlign.center,),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
                child: GestureDetector(
                  onTap: () => context.go('/'),
                  child: Container(
                    width: 200,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                      "Back", style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                  ),
                ),
              )
          ],
        )
      ),
    );
  }
}