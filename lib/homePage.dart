import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
//import 'package:weatherapp/defaultdata.dart';
import 'package:weatherapp/detailsPage.dart';
import 'package:weatherapp/setDataFromAPI.dart';

import 'LogIn/accountPage.dart';
import 'extraWeather.dart';

const mockupHeight = 812;

late Weather currentTemp;
late Weather tomorrowTemp;
late List<Weather> todayWeather;
late List<Weather> sevenDay;

String lat = "40.203316";
String lon = "-8.410257";
String city = "Coimbra";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    fetchData(lat, lon, city).then((value) {
      currentTemp = value[0];
      todayWeather = value[1];
      tomorrowTemp = value[2];
      sevenDay = value[3];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030317),
      body: currentTemp == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(child: CurrentWeather(getData)),
                const TodayWeather()
              ],
            ),
    );
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  const CurrentWeather(this.updateData, {Key? key}) : super(key: key);
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final scaleheight = MediaQuery.of(context).size.height;
    final textScale = scaleheight / mockupHeight;

    return GestureDetector(
      onTap: () {
        if (searchBar) {
          setState(() {
            searchBar = false;
          });
        }
      },
      child: GlowContainer(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        glowColor: const Color(0xff00A1FF).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(70), bottomRight: Radius.circular(70)),
        color: const Color(0xff00A1FF),
        spreadRadius: 7,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: searchBar
                  ? TextField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: const Color(0xff030317),
                          filled: true,
                          hintText: "Enter a city Name"),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) async {
                        CityModel? temp = await fetchCity(value);
                        if (temp == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xff030317),
                                  title: const Text("City not found"),
                                  content:
                                      const Text("Please check the city name"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Ok"))
                                  ],
                                );
                              });
                          searchBar = false;
                          return;
                        }
                        city = temp.name;
                        lat = temp.lat;
                        lon = temp.lon;
                        updating = true;
                        setState(() {});
                        widget.updateData();
                        searchBar = false;
                        updating = false;
                        setState(() {});
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.location_solid,
                            color: Colors.white),
                        GestureDetector(
                          onTap: () {
                            searchBar = true;
                            setState(() {});
                            focusNode.requestFocus();
                          },
                          child: Text(
                            " " + city,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 11),
              padding: const EdgeInsets.all(10),
              width: 120,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.white),
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(
                  "Updating",
                  textScaleFactor: textScale,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: Stack(
                  children: [
                    Positioned(
                      top: scaleheight / textScale - 850,
                      right: 0,
                      left: 0,
                      child: Image(
                        image: AssetImage(currentTemp.image),
                        height: MediaQuery.of(context).size.height - 430,
                        width: MediaQuery.of(context).size.height - 430,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      right: 0,
                      left: 0,
                      child: Column(
                        children: [
                          GlowText(
                            currentTemp.current.toString(),
                            style: TextStyle(
                                height: textScale,
                                fontSize: 70,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(currentTemp.name,
                              textScaleFactor: textScale,
                              style: const TextStyle(
                                fontSize: 15,
                              )),
                          Text(currentTemp.day,
                              textScaleFactor: textScale,
                              style: const TextStyle(
                                fontSize: 13,
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: const Divider(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ExtraWeather(currentTemp)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayWeather extends StatelessWidget {
  const TodayWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DetailPage(tomorrowTemp, sevenDay);
                    }));
                  },
                  child: Row(
                    children: const [
                      Text("7 days",
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey,
                        size: 15,
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 30,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    WeatherWidget(todayWeather[0]),
                    WeatherWidget(todayWeather[1]),
                    WeatherWidget(todayWeather[2]),
                    WeatherWidget(todayWeather[3])
                  ]),
            )
          ],
        ));
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  const WeatherWidget(this.weather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text(
            weather.current.toString() + "\u00B0",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          Image(
            image: AssetImage(weather.image),
            width: 45,
            height: 45,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            weather.time,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
