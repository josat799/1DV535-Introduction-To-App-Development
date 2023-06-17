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
      title: 'Flutter Demo',
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
          style: GoogleFonts.pacifico(fontSize: 48),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 200),
          child: Card(
            child: SizedBox(
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
              "https://scontent.farn2-2.fna.fbcdn.net/v/t1.6435-9/73388489_2539406379431769_8614658395145764864_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=ITTbUuaoT0QAX8JBpkJ&_nc_ht=scontent.farn2-2.fna&oh=00_AfC2gkjzXWyhs4Xyl6bCHdXAW1gcPdpCmjeBt28rng_Bsw&oe=64B50CA1"),
        ),
        Text("MSc Computer Science")
      ],
    );
  }
}
