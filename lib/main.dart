import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_actions/quick_actions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  stupidFunctionToKnowTheInformationBcImTired().then((aleluia) {
    runApp(
      MaterialApp(
        home: aleluia ? const HellOnEarth() : const LoginFormByChatGPTbecauseImTooooooLazy(),
      ),
    );
  });
}

Future<bool> stupidFunctionToKnowTheInformationBcImTired() async {
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  File file = File('${appDocumentsDirectory.path}/infoestudante.txt');

  if (file.existsSync()) {
    String fileContent = await file.readAsString();
    if (fileContent.isNotEmpty) {
      return true;
    }
    return false;
  } else {
    file.createSync();
    return false;
  }
}

class HellOnEarth extends StatefulWidget {
  const HellOnEarth({super.key});

  @override
  State<HellOnEarth> createState() => _HellOnEarthState();
}

class _HellOnEarthState extends State<HellOnEarth> {
  bool firstTimeIguess = false;
  String url = "https://inforestudante.ipiaget.org";

  Key webViewKey = UniqueKey();
  late InAppWebViewController _webViewController;

  Future<List<String>> getStupidInformation() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    File file = File('${appDocumentsDirectory.path}/infoestudante.txt');

    return file.readAsLines();
  }

  late String epicEmailOfStupidUser;
  late String epicPasswordOfStupidUser;

  @override
  void initState() {
    super.initState();

    getStupidInformation().then((value) {
      epicEmailOfStupidUser = value[0];
      epicPasswordOfStupidUser = value[1];
    });

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType == "notificacoes") {
          url = "https://inforestudante.ipiaget.org/nonio/util/menu.do?menu=10";
        } else if (shortcutType == "horario") {
          url = "https://inforestudante.ipiaget.org/nonio/util/menu.do?menu=23";
        }
        firstTimeIguess = true;
        if (_webViewController.getUrl().toString() != "https://inforestudante.ipiaget.org/nonio/security/login.do") {
          _webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
        } else {
          String functionLogin = """
                document.getElementById('username').value = '$epicEmailOfStupidUser';
                document.getElementById('password1').value = '$epicPasswordOfStupidUser';
                document.getElementsByClassName('button')[0].click();
              """;
          _webViewController
              .evaluateJavascript(source: functionLogin)
              .then((_) => {_webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)))});
        }
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'horario',
        localizedTitle: 'Horário',
        icon: 'launcher_icon',
      ),
      const ShortcutItem(
        type: 'notificacoes',
        localizedTitle: 'Notificações',
        icon: 'launcher_icon',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          key: webViewKey,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
          onLoadStop: (controller, currentUrl) async {
            String functionLogin = """
                document.getElementById('username').value = '$epicEmailOfStupidUser';
                document.getElementById('password1').value = '$epicPasswordOfStupidUser';
                  document.getElementsByClassName('button')[0].click();
                """;
            if (currentUrl.toString() != "https://inforestudante.ipiaget.org/nonio/security/login.do") {
              if (firstTimeIguess) {
                const String functionNotif = """
                  document.getElementById("link-menu-mob").click();
                  document.getElementsByClassName("menu_10")[0].click();
                """;
                switch (url) {
                  case "https://inforestudante.ipiaget.org/nonio/util/menu.do?menu=10":
                    await controller.evaluateJavascript(source: functionNotif);
                    break;
                  case "https://inforestudante.ipiaget.org/nonio/util/menu.do?menu=23":
                    controller.loadUrl(
                      urlRequest: URLRequest(
                        url: Uri.parse(url),
                      ),
                    );
                    break;
                  default:
                    break;
                }
                setState(() {
                  firstTimeIguess = false;
                });
              }
            }
            setState(() async {
              await controller.evaluateJavascript(source: functionLogin);
            });
          },
        ),
      ),
    );
  }
}

class LoginFormByChatGPTbecauseImTooooooLazy extends StatefulWidget {
  const LoginFormByChatGPTbecauseImTooooooLazy({super.key});

  @override
  State<LoginFormByChatGPTbecauseImTooooooLazy> createState() => _LoginFormByChatGPTbecauseImTooooooLazyState();
}

class _LoginFormByChatGPTbecauseImTooooooLazyState extends State<LoginFormByChatGPTbecauseImTooooooLazy> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordIsHidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordIsHidden = !_passwordIsHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Form'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: _passwordIsHidden,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: InkWell(
                    onTap: _togglePasswordVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 24,
                      ),
                      child: Icon(_passwordIsHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    getApplicationDocumentsDirectory().then((documentDir) {
                      File file = File('${documentDir.path}/infoestudante.txt');

                      file.writeAsString("${emailController.text}\n${passwordController.text}");

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HellOnEarth()),
                      );
                    });
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
