import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weatherapp/defaultdata.dart';

const mockupHeight = 812;

class ExtraWeather extends StatelessWidget {
  final Weather temp;
  const ExtraWeather(this.temp);

  @override
  Widget build(BuildContext context) {
    final scaleheight = MediaQuery.of(context).size.height;
    final textScale = scaleheight / mockupHeight;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Icon(
              CupertinoIcons.wind,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              temp.wind.toString() + " Km/h",
              textScaleFactor: textScale,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Wind",
              textScaleFactor: textScale,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
            const Icon(
              CupertinoIcons.drop,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              temp.humidity.toString() + " %",
              textScaleFactor: textScale,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Humidity",
              textScaleFactor: textScale,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
            const Icon(
              CupertinoIcons.cloud_rain,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              temp.chanceRain.toString() + " %",
              textScaleFactor: textScale,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Rain",
              textScaleFactor: textScale,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        )
      ],
    );
  }
}
