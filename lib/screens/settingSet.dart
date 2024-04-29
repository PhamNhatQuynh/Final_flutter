import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String selectedTermLanguage = 'Select Language';
  String selectedDefiLanguage = 'Select Language';
  String selectedVisible = 'Everyone';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.grey,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text("Language"),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 38,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.language,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Terms",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              _setTermLanguageOptionsDialog(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  selectedTermLanguage,
                                  style:
                                      const TextStyle(color: Colors.lightGreen),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.5),
                    Container(
                      height: 38,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.language,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Definitions",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              _setDefiLanguageOptionsDialog(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  selectedDefiLanguage,
                                  style:
                                      const TextStyle(color: Colors.lightGreen),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text("Privacy"),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 38,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.people,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Visible to",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              _setVisible(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  selectedVisible,
                                  style:
                                      const TextStyle(color: Colors.lightGreen),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setDefiLanguageOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    selectedDefiLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Vietnamese'),
                onTap: () {
                  setState(() {
                    selectedDefiLanguage = 'Vietnamese';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setTermLanguageOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    selectedTermLanguage = 'English';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Vietnamese'),
                onTap: () {
                  setState(() {
                    selectedTermLanguage = 'Vietnamese';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _setVisible(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Access', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Everyone'),
                onTap: () {
                  setState(() {
                    selectedVisible = 'Everyone';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Just me'),
                onTap: () {
                  setState(() {
                    selectedVisible = 'Just me';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
