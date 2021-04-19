import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Speed extends StatefulWidget {
  @override
  _SpeedState createState() => _SpeedState();
}

class _SpeedState extends State<Speed> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                    minimum: 0,
                    maximum: 200,
                    labelOffset: 30,
                    axisLineStyle: AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
                    majorTickStyle: MajorTickStyle(
                        length: 6, thickness: 4, color: Colors.white),
                    minorTickStyle: MinorTickStyle(
                        length: 3, thickness: 3, color: Colors.white),
                    axisLabelStyle: GaugeTextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
