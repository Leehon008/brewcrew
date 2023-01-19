import 'package:brewcrew/models/brew.dart';
import 'package:brewcrew/screens/home/settings_form.dart';
import 'package:brewcrew/services/auth_service.dart';
import 'package:brewcrew/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brew_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          title: const Text('Home to Brew Crew'),
          actions: <Widget>[
            Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0.0),
                  backgroundColor: MaterialStateProperty.all(Colors.brown[400]),
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.all(12.0)),
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 15)),
                ),
                onPressed: () async {
                  await auth.signOut();
                },
                label: const Text(
                  "Sign out",
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton.icon(
              label: const Text(''),
              onPressed: showSettingsPanel,
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0.0),
                backgroundColor: MaterialStateProperty.all(Colors.brown[400]),
                padding: MaterialStateProperty.all(const EdgeInsets.all(2.0)),
                textStyle:
                    MaterialStateProperty.all(const TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/coffee_bg.png'),
            ),
          ),
          child: const BrewList(),
        ),
      ),
    );
  }
}
