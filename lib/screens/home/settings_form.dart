import 'package:brewcrew/models/user.dart';
import 'package:brewcrew/services/database_service.dart';
import 'package:brewcrew/shared/constants.dart';
import 'package:brewcrew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  SettingsFormState createState() => SettingsFormState();
}

class SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  String selectedItem = '0';
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  // form values
  String? _currentName;
  String _currentSugars = '0';
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return StreamBuilder<UserDataModel>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserDataModel? userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData!.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: userData.sugars ?? _currentSugars, //selectedItem
                    decoration: textInputDecoration,
                    items: sugars
                        .map<DropdownMenuItem<String>>(
                          (String _value) => DropdownMenuItem<String>(
                            value:
                                _value, // add this property an pass the _value to it
                            child: Text('$_value sugars'),
                          ),
                        )
                        .toList(),
                    //     .map((sugar) {
                    //   return DropdownMenuItem(
                    //     value: sugar,
                    //     child: Text('$sugar sugars'),
                    //   );
                    // }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val!),
                  ),
                  const SizedBox(height: 10.0),
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  ElevatedButton(
                    // color: Colors.pink[400],
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? snapshot.data!.sugars,
                            _currentName ?? snapshot.data!.name,
                            _currentStrength ?? snapshot.data!.strength);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
