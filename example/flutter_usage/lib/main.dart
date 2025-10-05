import 'package:flutter/material.dart';
import 'package:icon_font_generator_example/src/svg_gen.dart';

import 'ui/icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: MediaQuery.sizeOf(context).width < 600
        ? NavigationBar(
            destinations: [
              NavigationDestination(
                icon: Icon(UiIcons.account),
                label: 'Generator',
              ),
              NavigationDestination(
                icon: Icon(UiIcons.arrowLeft),
                label: 'Example',
              ),
            ],
          )
        : null,

    body: LayoutBuilder(
      builder: (context, constraints) {
        final body = IndexedStack(
          index: index,
          children: [SvgGen(), ExampleUIIcon()],
        );
        if (constraints.maxWidth < 600) {
          return body;
        }
        return Row(
          children: [
            Flexible(
              child: Drawer(
                elevation: 1,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      title: Text('Generator'),
                      leading: Icon(Icons.build),
                      textColor: index == 0 ? Colors.white : Colors.black,
                      tileColor: index == 0 ? Colors.blue : null,
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                      title: Text('Example'),
                      leading: Icon(Icons.settings),
                      textColor: index == 1 ? Colors.white : Colors.black,
                      tileColor: index == 1 ? Colors.blue : null,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 3, child: body),
          ],
        );
      },
    ),
  );
}

class ExampleUIIcon extends StatelessWidget {
  const ExampleUIIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children:
            [
                  UiIcons.account,
                  UiIcons.arrowLeft,
                  UiIcons.collection,
                  UiIcons.arrowRight,
                ]
                .map(
                  (iconData) => Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(iconData),
                  ),
                )
                .cast<Widget>()
                .toList(),
      ),
    );
  }
}
