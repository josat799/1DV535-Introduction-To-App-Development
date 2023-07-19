import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TheMeCard(),
    );
  }
}

enum InformationTileOption {
  phone,
  email,
  website,
}

class TheMeCard extends StatelessWidget {
  const TheMeCard({super.key});

  final Map<InformationTileOption, String> userInformation = const {
    InformationTileOption.email: "josef.atoui@live.se",
    InformationTileOption.phone: "0707 769116",
    InformationTileOption.website: "https://github.com/josat799"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Josef Atoui",
          style: GoogleFonts.pacifico(fontSize: 32),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  addCardHeder(),
                  addUserInformation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column addUserInformation() {
    return Column(
        children: InformationTileOption.values
            .map((e) => addInformationTile(e, userInformation[e]!))
            .toList());
  }

  ListTile addInformationTile(
      InformationTileOption option, String information) {
    return switch (option) {
      InformationTileOption.phone => ListTile(
          leading: const Icon(Icons.phone_android_outlined),
          title: Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.blue),
              text: information,
              recognizer: TapGestureRecognizer()
                ..onTap =
                    () async => await launchUrl(Uri.parse('tel:$information')),
            ),
          ),
        ),
      InformationTileOption.email => ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.blue),
              text: information,
              recognizer: TapGestureRecognizer()
                ..onTap = () async =>
                    await launchUrl(Uri.parse('mailto:$information')),
            ),
          ),
        ),
      InformationTileOption.website => ListTile(
          leading: const Icon(Icons.web_outlined),
          title: Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.blue),
              text: information,
              recognizer: TapGestureRecognizer()
                ..onTap = () async => launchUrl(Uri.parse(information)),
            ),
          ),
        ),
    };
  }

  Row addCardHeder() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              "https://scontent-arn2-1.xx.fbcdn.net/v/t1.6435-1/73388489_2539406379431769_8614658395145764864_n.jpg?stp=dst-jpg_p160x160&_nc_cat=107&ccb=1-7&_nc_sid=dbb9e7&_nc_ohc=CRBXOEk_oV4AX_7JO_Y&_nc_ht=scontent-arn2-1.xx&oh=00_AfBUQL-pRPd-pb_4rRODxSUbDz84JF1R5tmzidkpdJaTjg&oe=64DF0D6B"),
        ),
        Flexible(fit: FlexFit.loose, child: Text("MSc Computer Science"))
      ],
    );
  }
}
