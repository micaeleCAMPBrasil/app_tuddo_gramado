import 'package:flutter/material.dart';

import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

List appLanguagesList = ['English (USA)', 'Hindi'];
List downloadWithList = ['WiFi Only', 'Mobile Data and WiFi'];
List downloadQualityList = ['HD (High Definition) 720p', 'Full HD 1080p'];

class _SettingsPageState extends State<SettingsPage> {
  Object appLanguage = 'English (USA)';
  Object downloadWith = 'WiFi Only';
  Object downloadQuality = 'HD (High Definition) 720p';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(
          backgroundColor: color00,
          title: 'Settings',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            heightSpace15,
            Text('Preferred App Language', style: color94Regular16),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                value: appLanguage,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 3,
                ),
                dropdownColor: primaryColor,
                items: appLanguagesList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: whiteMedium18),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    appLanguage = value!;
                  });
                },
              ),
            ),
            Divider(color: color28),
            heightSpace10,
            Text('Downloads', style: color94Regular16),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                value: downloadWith,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 3,
                ),
                dropdownColor: primaryColor,
                items: downloadWithList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: whiteMedium18),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    downloadWith = value!;
                  });
                },
              ),
            ),
            Divider(color: color00),
            heightSpace10,
            Text('Download Video Quality', style: color94Regular16),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                value: downloadQuality,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 3,
                ),
                dropdownColor: primaryColor,
                items: downloadQualityList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, style: whiteMedium18),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    downloadQuality = value!;
                  });
                },
              ),
            ),
            Divider(color: color00),
            heightSpace10,
          ]),
        ],
      ),
    );
  }
}
