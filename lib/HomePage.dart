import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stotext;
import 'package:fuzzy/fuzzy.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final stotext.SpeechToText _speechToText = stotext.SpeechToText();
  bool isListening = false;
  TextEditingController _textController = TextEditingController();

  final Map<String, String> routes = {
    "etam kawa": "/etam_kawa",
    "bps": "/bps",
    "hrgs": "/hrgs",
    "pic bps": "/pic_bps",
    "pscm": "/pscm",
    "am service": "/am_service",
    "cuti": "/cuti"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                      onPressed: listening,
                    ),
                  ),
                ),

                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(11, 80, 0, 0),
                        child: GestureDetector(
                          onTap: () => context.go('/etam_kawa'),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "Etam Kawa", style: TextStyle(color: Colors.white, fontSize: 17),),
                          ),
                        ),
                        
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                        child: GestureDetector(
                          onTap: () => context.go('/bps'),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "BPS", style: TextStyle(color: Colors.white, fontSize: 19),),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 80, 20, 0),
                        child: GestureDetector(
                          onTap: () => context.go('/hrgs'),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "HRGS", style: TextStyle(color: Colors.white, fontSize: 19),),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 20),
                
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(11, 80, 0, 0),
                        child: GestureDetector(
                          onTap: () => context.go('/pic_bps'),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "PIC-BPS", style: TextStyle(color: Colors.white, fontSize: 17),),
                          ),
                        ),
                        
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                        child: GestureDetector(
                          onTap: () => context.go('/pscm'),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "PSCM", style: TextStyle(color: Colors.white, fontSize: 19),),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 80, 20, 0),
                        child: GestureDetector(
                          onTap: () => context.go('/am_service'),
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              "AM Service", style: TextStyle(color: Colors.white, fontSize: 19),),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void listening() async {
    if (!isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print("Status: $status"),
        onError: (error) => print("Error: $error"),
      );

      if (available) {
        setState(() => isListening = true);
        _speechToText.listen(
          onResult: (result) {
            if (result.finalResult) {
              setState(() {
                List<String> matchedRoutes = findMatchingRoutes(result.recognizedWords);
                _textController.text = matchedRoutes.isNotEmpty ? matchedRoutes.first : result.recognizedWords;
                
                if (matchedRoutes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Incorrect input, please try again!"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (matchedRoutes.length == 1) {
                  context.go(routes[matchedRoutes.first]!);
                } else {
                  showSelectionDialog(matchedRoutes);
                }
              });
            }
          },
          listenMode: stotext.ListenMode.dictation,
          localeId: "id-ID",
          partialResults: true,
          onDevice: false,
        );
      }
    } else {
      setState(() => isListening = false);
      _speechToText.stop();
    }
  }

  List<String> findMatchingRoutes(String input) {
    final words = ["etam kawa", "bps", "hrgs", "pic bps", "pscm", "am service","cuti"];
    final fuzzy = Fuzzy<String>(words, options: FuzzyOptions(threshold: 0.3));
    final result = fuzzy.search(input);
    return result.map((r) => r.item).toList();
  }

  void showSelectionDialog(List<String> matchedRoutes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: matchedRoutes.map((route) {
              return ListTile(
                title: Text(route.toUpperCase()),
                onTap: () {
                  Navigator.pop(context);
                 context.go(routes[route]!);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
