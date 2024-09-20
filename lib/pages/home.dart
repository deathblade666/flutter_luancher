import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/pages/settings.dart';
import 'package:flutter_launcher/widgets/tasks.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:flutter/services.dart';
import 'package:one_clock/one_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';




class launcher extends StatefulWidget {
  launcher(this.prefs,{super.key});
  SharedPreferences prefs;
  

  @override
  State<StatefulWidget> createState() => _launcherState();
}

  void onClosed(){
  
  }
  


class _launcherState extends State<launcher>{
  bool enabeBottom = true;
  bool showAppList = false;
  final TextEditingController _searchController = TextEditingController();
  List<String> installedApps = [];
  List<AppInfo> _filteredItems = [];
  List<AppInfo> _app = [];
  bool hideDateTime = true;
  FocusNode focusOnSearch = FocusNode();
  String date = "";
  bool handle = true;
  bool hideDate = true;
  bool hideMainGesture = true;
  static const platform = MethodChannel('notification_shade');
  static const widgetplatform = MethodChannel('widget_channel');
  String weekDay = formatDate(DateTime.now(),[DD,]);
  String monthDay = formatDate(DateTime.now(),[MM, ' ', d]);
  String engine = "";
  var _tapPosition;
  bool widgetVis = true;
  String pinnedAppInfo = "";
  String pinnedAppInfo2 = "";
  String pinnedAppInfo3 = "";
  String pinnedAppInfo4 = "";
  var appIconrestored;
  var appIcon;
  var appIcon2;
  var appIcon3;
  var appIcon4;
  bool noAppPinned = false;
  double searchHieght = 40;
  var appNumber;
  String appName ="";
  bool hideIcon1 = false;
  bool hideIcon2 = false;
  bool hideIcon3 = false;
  bool hideIcon4 = false;
  bool displayTasks = false;
  bool enableTasks = false;


 focusListener(){
    if (focusOnSearch.hasFocus){
      setState(() {
        handle = false;
      });
    } else if (!focusOnSearch.hasFocus){
      setState(() {
        handle = true;
      });
    }
  }
  @override
  void initState(){
    _tapPosition = const Offset(0.0, 0.0);
    super.initState();
    fetchApps();
    loadPrefs();
    focusOnSearch.addListener(focusListener);
  }

  void loadPrefs() {
    widget.prefs.reload();
    String? provider = widget.prefs.getString('provider');
    bool? toggleStats = widget.prefs.getBool('StatusBar');
    bool? widgetsEnabled = widget.prefs.getBool("EnableWidgets");
    String? appIconEncoded = widget.prefs.getString("appIcon");
    bool? togglePinApp = widget.prefs.getBool("togglePin");
    int? appNumber1 = widget.prefs.getInt("App1");
    int? appNumber2 = widget.prefs.getInt("App2");
    int? appNumber3 = widget.prefs.getInt("App3");
    int? appNumber4 = widget.prefs.getInt("App4");
    String? appName1 = widget.prefs.getString("Pinned App1");
    String? appName2 = widget.prefs.getString("Pinned App2");
    String? appName3 = widget.prefs.getString("Pinned App3");
    String? appName4 = widget.prefs.getString("Pinned App4");
    
    if (togglePinApp != null){
      pinAppToggle(togglePinApp);
    }
    if (provider != null){
      searchProvider(provider);
    } else {
      provider = "duckduckgo.com/?q=";
      searchProvider(provider);
    }
    if (toggleStats != null) {
      toggleStatusBar(toggleStats);
    }
    if (widgetsEnabled != null){
      widgetToggle(widgetsEnabled);
    }
    if (appNumber1 != null && appName1 != null){
      appNumber = appNumber1;
      appName = appName1;
      pinnedApp(appName, appNumber);
      hideIcon1 = true;
    } else {
      hideIcon1 = false;
    }
    if (appNumber2 != null && appName2 != null){
      appNumber = appNumber2;
      appName = appName2;
      pinnedApp(appName, appNumber);
      hideIcon2 = true;
    } else {
      hideIcon2 = false;
    }
    if (appNumber3 != null && appName3 != null){
      appName = appName3;
      appNumber = appNumber3;
      pinnedApp(appName, appNumber);
      hideIcon3 = true;
    } else {
      hideIcon3 = false;
    }
    if (appNumber4 != null && appName4 != null){
      appName = appName4;
      appNumber = appNumber4;
      pinnedApp(appName, appNumber);
      hideIcon4 = true;
    } else {
      hideIcon4 = false;
    }
    if (appIconEncoded != null){
      appIconrestored = base64Decode(appIconEncoded);
      var iconAsList = Uint8List.fromList(appIconrestored);
      restoreAppIcon(iconAsList);
    }
  }

  void fetchApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true,true);
    setState(() {
      installedApps = apps.map((app) => app.name).toList();
      _app = apps;
      _filteredItems = _app;
    });
  }

  void enableSheet(DragStartDetails) {
    setState(() {
      enabeBottom = !enabeBottom;
    });
  }

  void pinAppToggle (togglePinApp){
    setState(() {
      noAppPinned = togglePinApp;
      if (noAppPinned == true && hideIcon1 == false && hideIcon2 == false && hideIcon3 == false && hideIcon4 == false){
        searchHieght = 40;
      } else if (noAppPinned == true && widgetVis == false) {
        searchHieght = 57;
      } else if (widgetVis == true && noAppPinned == false) {
        searchHieght = 40;
      } else if (noAppPinned == true && widgetVis == true) {
        searchHieght = 87;
      } else {
        searchHieght = 40;
      }
    });
  }

  @override
  void dispose() {
    focusOnSearch.dispose();
    focusOnSearch.removeListener(focusListener);
    super.dispose();
  }

  void searchProvider(provider){
    setState(() {
      engine = provider;
    });
  }

  void toggleStatusBar(toggleStats){
    if (toggleStats == true) {
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    } else if (toggleStats == false){
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top
        ]);
      });
    }
  }
  void widgetToggle(widgetsEnabled) {
      setState(() {
        widgetVis = widgetsEnabled;
        if (noAppPinned == true && widgetVis == true) {
          searchHieght = 87;
        } else if (noAppPinned == false && widgetVis == true) {
          searchHieght = 40;
        } else if (widgetVis == false && noAppPinned == true) {
          searchHieght = 57;
        } else {
          searchHieght = 40;
        }
      });
  }

  void pinnedApp(String appName, int appNumber) async {
    AppInfo app = await InstalledApps.getAppInfo(appName);
      if (appNumber == 1){
        setState(() {
          pinnedAppInfo = appName;
          appIcon = app.icon;
          hideIcon1 = true;
        });
      }
      if (appNumber == 2) {
        setState(() {
          pinnedAppInfo2 = appName;
          appIcon2 = app.icon;
          hideIcon2 = true;
        });
        
      } else if (appNumber == 3){
        setState(() {
          pinnedAppInfo3 = appName;
          appIcon3 = app.icon;
          hideIcon3 = true;
        });
        
      } else if (appNumber == 4){
        setState(() {
          pinnedAppInfo4 = appName;
          appIcon4 = app.icon;
          hideIcon4 = true;
        });
        
      }
  }

  void restoreAppIcon(Uint8List){
    appIcon = appIconrestored;
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        bottomSheet: BottomSheet(
          onClosing: onClosed, 
          builder: (BuildContext context){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: widgetVis,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [ 
                        Icon(Icons.keyboard_arrow_up, size: 30,),
                      ],
                    ), 
                    onVerticalDragStart: (details) {
                      showModalBottomSheet<void>(showDragHandle: true ,context: context, builder: (BuildContext context) {
                        return PageView(
                          children: <Widget>[
                            SizedBox.expand(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: const Center( 
                                        child: Text("Click here to add your widgets"),
                                      ),
                                      onTap: () async {
                                        showDialog(context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text("Widgets"),
                                            actions: [
                                              SwitchListTile(
                                                title: Text("Tasks"),
                                                value: enableTasks, 
                                                onChanged: (value) {
                                                  bool enableTasks = value;
                                                  setState(() {
                                                    print(enableTasks);
                                                    enableTasks = !enableTasks;
                                                    displayTasks = enableTasks;
                                                  });
                                                }
                                              )
                                            ],
                                          );
                                        });
                                      },
                                    ),
                                    Visibility(
                                      visible: displayTasks,
                                      child: Tasks(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Center( 
                              child: Text("Page 2"),
                            ),
                          ],
                        );   
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: noAppPinned,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      //TODO: Set visibility based on it sfavorite has been set.

                      Visibility(
                        visible: hideIcon1,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo);
                          },
                          icon: appIcon != null 
                            ? Image.memory(appIcon, height: 30,)
                            : const Icon(Icons.android),
                        ), 
                      ),
                      Visibility(
                        visible: hideIcon2,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo2);
                          },
                          icon: appIcon2 != null 
                            ? Image.memory(appIcon2, height: 30,)
                            : const Icon(Icons.android),
                        ), 
                      ),
                      Visibility(
                        visible: hideIcon3,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo3);
                          },
                          icon: appIcon3 != null 
                            ? Image.memory(appIcon3, height: 30,)
                            : const Icon(Icons.android),
                        ),
                      ),
                      Visibility(
                        visible: hideIcon4,
                        child: IconButton(
                          onPressed: () {
                            InstalledApps.startApp(pinnedAppInfo4);
                          },
                          icon: appIcon4 != null 
                            ? Image.memory(appIcon4, height: 30,)
                            : const Icon(Icons.android),
                        ),
                      ), 
                    ],
                  )
                )
              ]
            );
          }
        ),
        body: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            Padding(padding: EdgeInsets.only(bottom: searchHieght)), // 38 when widget only, 87 when widget and favorites. 55-60 when only favs
            Container( 
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: SearchBar(
                focusNode: focusOnSearch,
                constraints: const BoxConstraints(
                  maxHeight: 40,
                  minHeight: 40
                ),
                elevation: const WidgetStatePropertyAll(0.0),
                //leading: 
                onChanged: (String value) async {
                  String s = _searchController.text;
                  setState(() {
                    _filteredItems = _app.where(
                      (_app) => _app.name.toLowerCase().contains(s.toLowerCase()),
                      ).toList();
                      if (value.isNotEmpty){
                        showAppList = true;
                        hideDate = false;
                        hideMainGesture = false;
                      } else {
                        showAppList=false;
                        hideDate = true;
                      }
                    });
                },
                onTapOutside: (value){
                  focusOnSearch.unfocus();
                },
                onSubmitted: (String value) async {
                  List<AppInfo> apps = await InstalledApps.getInstalledApps();
                  String userInput = _searchController.text.toLowerCase();
                  List<AppInfo> matchedApps = apps.where(
                    (app) => app.name.toLowerCase().contains(userInput),
                    ).toList();

                  if (matchedApps.isNotEmpty) {
                    InstalledApps.startApp(matchedApps.first.packageName);
                  } else if  (userInput.isURL()) {
                    String inputURL = "https://$userInput";
                      final Uri url = Uri.parse(inputURL);
                      await launchUrl(url);
                  } else { 
                    String Search = "https://$engine$userInput";
                    final Uri searchURL = Uri.parse(Search);
                    await launchUrl(searchURL);
                  }
                  _searchController.clear();
                  setState(() {
                    showAppList = false;
                    hideMainGesture = true;
                    hideDate = true;
                  });
                },
                controller: _searchController,
                onTap: () {
                  setState(() {
                    showAppList = !showAppList;
                    if (showAppList == true){
                      hideDate = false;
                      hideMainGesture = false;
                    } else {
                      hideDate = true;
                      hideMainGesture = true;
                    }
                  });
                },
              )
            ),
            Visibility(
              visible: showAppList,
              child: Expanded(
                child: ListView.builder( reverse: true, shrinkWrap: true, itemCount: _filteredItems.length, itemBuilder: (context, index){
                  AppInfo app = _filteredItems[index];
                  return Container(
                    height: 50,
                    child: ListTile(
                      onTap: () {
                        InstalledApps.startApp(app.packageName);
                      },
                      leading: app.icon != null
                        ? Image.memory(app.icon!, height: 30,)
                        : const Icon(Icons.android),
                      title: Text(app.name),
                    )
                  );
                })
              )
            ),
            const Padding(padding: EdgeInsets.all(3)),
            Visibility(
              visible: hideDate,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        weekDay + '\n$monthDay',
                        textScaler: MediaQuery.textScalerOf(context),
                        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20), 
                      ),
                    ),
                    const Expanded(child: Padding(padding: EdgeInsets.all(1))),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.primary,
                      thickness: 1.5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 2),
                     child: DigitalClock(
                        digitalClockTextColor: Theme.of(context).colorScheme.primary,
                        datetime: DateTime.now(),
                        showSeconds: false,
                        textScaleFactor: 1.8,
                        format: "h:mm",
                      ),
                    ),
                  ],
                ),
              )
            ),
            Visibility(
              visible: hideMainGesture,
              child: Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details){
                    setState(() {
                      _tapPosition = details.globalPosition;
                    });
                  },
                  onLongPress: () async {
                    double left = _tapPosition.dx - 110;
                    double top = _tapPosition.dy;
                    double right = _tapPosition.dx;
                    await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(left, top, right, 0),
                      items: [
                        PopupMenuItem(
                          child: const Text("Settings"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => settingeMenu(onProviderSet: searchProvider, widget.prefs, onStatusBarToggle: toggleStatusBar, enableWidgets: widgetToggle, _app, onPinnedApp: pinnedApp,ontogglePinApp: pinAppToggle,onClear: loadPrefs,)),
                            );
                          },
                        )
                      ]
                    );
                  },
                  onTap: (){
                    focusOnSearch.unfocus();
                  },
                  onVerticalDragUpdate: (details) async {
                    int sensitivity = 3;
                    if (details.delta.dy > sensitivity) {
                      // Do a thing on down swipe
                      await platform.invokeMethod('openNotificationShade');
                    } else if (details.delta.dy < sensitivity) {
                      // do a thing on up swipe
                      focusOnSearch.requestFocus();
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    int sensitivity = 2;
                    if (details.delta.dx > sensitivity){
                       // Do a thing on Right swipe
                      showDialog(context: context, builder: (BuildContext context){
                      return const AlertDialog(
                        title: Text("You swiped Right!"),
                      );
                    });
                    } else if (details.delta.dx < sensitivity) {
                      // do a thing on Left swipe
                      showDialog(context: context, builder: (BuildContext context){
                        return const AlertDialog(
                          title: Text("You swiped Left!"),
                        );
                      });
                    }
                  },
                )
              )
            )
          ]
        )
      )
    );
  }
}