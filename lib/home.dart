import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static const MAX_LENGTH = 3;
  static const MIN_CPS = 0;
  static const MAX_CPS = 100;
  static var START_KEY = HotKey(
      key: PhysicalKeyboardKey.keyV,
      modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
      scope: HotKeyScope.system);
  var cps = MIN_CPS;
  var textController = TextEditingController(text: MIN_CPS.toString());
  var enabled = false;

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      var text = int.tryParse(textController.text.trim());
      if (text == null) return;
      if (text < MIN_CPS) {
        text = MIN_CPS;
        textController.value = TextEditingValue(text: MIN_CPS.toString());
      } else if (text > MAX_CPS) {
        text = MAX_CPS;
        textController.value = TextEditingValue(text: MAX_CPS.toString());
      }

      cps = text;
    });

    setupHotKeys();
  }

  Future<void> setupHotKeys() async {
    await hotKeyManager.register(START_KEY, keyDownHandler: (hotkey) {
      enabled = !enabled;

      if (enabled) {
        final mouse = calloc<INPUT>();
        mouse.ref.type = INPUT_TYPE.INPUT_MOUSE;
        mouse.ref.mi.dwFlags = MOUSE_EVENT_FLAGS.MOUSEEVENTF_LEFTDOWN;
        SendInput(1, mouse, sizeOf<INPUT>());

        Sleep(1000);
        mouse.ref.mi.dwFlags = MOUSE_EVENT_FLAGS.MOUSEEVENTF_RIGHTUP;
        SendInput(1, mouse, sizeOf<INPUT>());

        free(mouse);
    }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    disposeHotkeys();
    super.dispose();
  }

  Future<void> disposeHotkeys() async {
    await hotKeyManager.unregister(START_KEY);
    await hotKeyManager.unregisterAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 200,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(MAX_LENGTH),
              ],
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Clicks Per Second",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
