import 'package:weather_app/custom_widgets/custom_graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeatherGraphTemplate extends StatefulWidget {
  EdgeInsetsGeometry padding;
  List<WeatherData> weatherData;
  String title;
  String unit;

  WeatherGraphTemplate({required this.padding, required this.weatherData, required this.title, required this.unit});

  @override
  State<WeatherGraphTemplate> createState() => _WeatherGraphTemplateState();
}

class _WeatherGraphTemplateState extends State<WeatherGraphTemplate> {
  @override
  Widget build(BuildContext context) {
    return CustomGraphWidget(
        padding: widget.padding,
        child: SfCartesianChart(
          margin: const EdgeInsets.all(20),
          plotAreaBorderWidth: 0,
          title: ChartTitle(
            text: "Max ${widget.title}",
            textStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
          ),
          primaryXAxis: const CategoryAxis(
              majorGridLines: MajorGridLines(width: 0), majorTickLines: MajorTickLines(width: 0), interval: 10, labelRotation: -90),
          primaryYAxis: const NumericAxis(
            isVisible: false,
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
          ),
          series: <CartesianSeries>[
            LineSeries<WeatherData, String>(
              // color: MyConst.primaryColor,
              color: Theme.of(context).colorScheme.primary,
              dataSource: widget.weatherData,
              xValueMapper: (WeatherData data, _) => data.date,
              yValueMapper: (WeatherData data, _) => data.value,
              enableTooltip: true,
              markerSettings: const MarkerSettings(isVisible: true, shape: DataMarkerType.verticalLine, height: 4, width: 4),
            )
          ],
          zoomPanBehavior: ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            header: "Max ${widget.title}",
            format: 'point.x : point.y ${widget.unit}',
            color: Theme.of(context).colorScheme.primaryContainer,
            textStyle: Theme.of(context).textTheme.labelLarge,
            elevation: 2,
            shadowColor: Colors.grey,
            canShowMarker: true,
          ),
        ));
  }
}

class WeatherData {
  final String date;
  final double value;

  WeatherData(this.date, this.value);
}
