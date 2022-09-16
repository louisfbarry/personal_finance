import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance/l10n/l10n.dart';
import 'package:finance/provider/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Language extends StatefulWidget {
  Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  int selectedLang = 1;

  getLang() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lang = prefs.getInt('language');
    setState(() {
      selectedLang = (lang == null) ? 1 : lang;
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.language,
          style: const TextStyle(fontSize: 15),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(children: [
          RadioListTile<int>(
              value: 1,
              groupValue: selectedLang,
              title: Text(
                "English",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]),
              ),
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt('language', 1);
                setState(() {
                  selectedLang = 1;
                  final provider =
                      Provider.of<LocaleProvider>(context, listen: false);
                  provider.setLocale(Locale('en'));
                });
              }),
          RadioListTile<int>(
              value: 2,
              groupValue: selectedLang,
              title: Text(
                "မြန်မာ",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]),
              ),
              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setInt('language', 2);
                setState(() {
                  selectedLang = 2;
                  final provider =
                      Provider.of<LocaleProvider>(context, listen: false);
                  provider.setLocale(Locale('my'));
                });
              }),
        ]),
      ),
    );
  }
}
