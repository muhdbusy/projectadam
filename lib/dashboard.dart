import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'profilepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farm Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DatabaseReference _databaseRef;

  String rssiValue = '0';
  String soilValue = '0';
  String humidityValue = '0';
  String temperatureValue = '0';
  String ldrValue = '0';
  bool pumpSwitch = false;
  bool autoMode = false;
  String lastUpdated = 'Loading...';

  List<FlSpot> soilData = [];
  List<FlSpot> humidityData = [];
  List<FlSpot> temperatureData = [];
  List<FlSpot> ldrData = [];
  List<String> timeLabels = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _startListeningToData();
  }

  void _initializeFirebase() {
    try {
      _databaseRef = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://roboticarm-fac31-default-rtdb.asia-southeast1.firebasedatabase.app/",
      ).ref();
      debugPrint("Firebase initialized successfully");
    } catch (e) {
      debugPrint("Firebase initialization error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firebase init error: $e")),
      );
    }
  }

  void _startListeningToData() {
    _databaseRef.child('sensor_data').onValue.listen((event) {
      final data = event.snapshot.value;
      debugPrint("Data received: $data");

      if (data == null) {
        debugPrint("No data available");
        return;
      }

      if (data is Map) {
        setState(() {
          rssiValue = (data['rssi'] ?? 0).toString();
          soilValue = (data['soil_moisture'] ?? 0).toString();
          humidityValue = (data['humidity'] ?? 0).toString();
          temperatureValue = (data['temperature'] ?? 0).toString();
          ldrValue = (data['ldr'] ?? 0).toString();

          lastUpdated = DateFormat('MMM d, h:mm a').format(DateTime.now());

          // Update chart data
          String timeLabel = DateFormat('h:mm a').format(DateTime.now());
          timeLabels.add(timeLabel);
          if (timeLabels.length > 10) timeLabels.removeAt(0);

          _addChartData(soilData, soilValue);
          _addChartData(humidityData, humidityValue);
          _addChartData(temperatureData, temperatureValue);
          _addChartData(ldrData, ldrValue);

          // Auto mode logic
          if (autoMode) {
            double moisture = double.tryParse(soilValue) ?? 0;
            bool shouldPumpBeOn = moisture < 20;
            if (shouldPumpBeOn != pumpSwitch) {
              _updatePumpSwitch(shouldPumpBeOn);
            }
          }
        });
      }
    }, onError: (error) {
      debugPrint("Sensor read error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data error: $error")),
      );
    });

    _databaseRef.child('control/pump').onValue.listen((event) {
      final value = event.snapshot.value;
      debugPrint("Pump status: $value");

      setState(() {
        pumpSwitch = value == true || value == 1 || value == 'true';
      });
    }, onError: (error) {
      debugPrint("Switch read error: $error");
    });

    _databaseRef.child('control/auto_mode').onValue.listen((event) {
      final value = event.snapshot.value;
      debugPrint("Auto mode status: $value");

      setState(() {
        autoMode = value == true || value == 1 || value == 'true';
      });
    }, onError: (error) {
      debugPrint("Auto mode read error: $error");
    });
  }

  void _addChartData(List<FlSpot> dataList, String value) {
    final numericValue = double.tryParse(value) ?? 0;
    dataList.add(FlSpot(dataList.length.toDouble(), numericValue));
    if (dataList.length > 10) dataList.removeAt(0);
  }

  void _updatePumpSwitch(bool value) {
    if (autoMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot manually control pump in auto mode")),
      );
      return;
    }

    _databaseRef.child('Actuator/led').set(value).then((_) {
      setState(() {
        pumpSwitch = value;
      });
    }).catchError((error) {
      debugPrint("Pump update error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update pump: $error")),
      );
    });
  }

  void _updateAutoMode(bool value) {
    _databaseRef.child('control/auto_mode').set(value).then((_) {
      setState(() {
        autoMode = value;
      });
    }).catchError((error) {
      debugPrint("Auto mode update error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update auto mode: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Farm Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ProfilePage()),
              );
            },
            icon: const Icon(CupertinoIcons.profile_circled, size: 28),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade100],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(),
                      const SizedBox(height: 12),
                      _buildSensorGrid(),
                      const SizedBox(height: 12),
                      _buildActuatorControls(),
                      const SizedBox(height: 12),
                      _buildCharts(),
                      const SizedBox(height: 12),
                      _buildFarmHealth(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    String healthStatus = 'Good';
    Color statusColor = Colors.green;
    double soilMoisture = double.tryParse(soilValue) ?? 0;

    if (soilMoisture < 20) {
      healthStatus = 'Critical';
      statusColor = Colors.red;
    } else if (soilMoisture < 30) {
      healthStatus = 'Needs Water';
      statusColor = Colors.orange;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Farm Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    healthStatus,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: $lastUpdated',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.wifi,
                  color: _getSignalColor(int.tryParse(rssiValue) ?? 0),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Signal: $rssiValue dBm',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -60) return Colors.lightGreen;
    if (rssi >= -70) return Colors.yellow;
    if (rssi >= -80) return Colors.orange;
    return Colors.red;
  }

  Widget _buildSensorGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sensor Readings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 340,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              _buildSensorCard(
                'Moisture',
                '$soilValue%',
                Icons.grass_outlined,
                Colors.brown.shade300,
                _getMoistureStatus(double.tryParse(soilValue) ?? 0),
              ),
              _buildSensorCard(
                'Humidity',
                '$humidityValue%',
                Icons.water_drop_outlined,
                Colors.blue.shade300,
                _getHumidityStatus(double.tryParse(humidityValue) ?? 0),
              ),
              _buildSensorCard(
                'Temp',
                '$temperatureValue°C',
                Icons.thermostat_outlined,
                Colors.red.shade300,
                _getTemperatureStatus(double.tryParse(temperatureValue) ?? 0),
              ),
              _buildSensorCard(
                'Light Level',
                '$ldrValue lux',
                Icons.wb_sunny_outlined,
                Colors.amber.shade300,
                _getLightStatus(double.tryParse(ldrValue) ?? 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMoistureStatus(double value) {
    if (value < 20) return 'Very Dry';
    if (value < 40) return 'Dry';
    if (value < 60) return 'Optimal';
    if (value < 80) return 'Moist';
    return 'Wet';
  }

  String _getHumidityStatus(double value) {
    if (value < 30) return 'Low';
    if (value < 60) return 'Optimal';
    return 'High';
  }

  String _getTemperatureStatus(double value) {
    if (value < 15) return 'Cold';
    if (value < 25) return 'Optimal';
    return 'Hot';
  }

  String _getLightStatus(double value) {
    if (value < 200) return 'Dark';
    if (value < 500) return 'Dim';
    if (value < 800) return 'Bright';
    return 'Very Bright';
  }

  Widget _buildSensorCard(String title, String value, IconData icon, Color color, String status) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 120,
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActuatorControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Controls',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Auto/Manual Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.grey.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Operation Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: autoMode,
                      onChanged: _updateAutoMode,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: autoMode
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        autoMode ? Icons.auto_awesome : Icons.touch_app,
                        color: autoMode ? Colors.blue : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          autoMode
                              ? 'Auto mode (Pump controlled by soil moisture)'
                              : 'Manual mode (Pump controlled manually)',
                          style: TextStyle(
                            fontSize: 13,
                            color: autoMode ? Colors.blue : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Pump Control
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.water,
                          color: Colors.blue.shade400,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Water Pump',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: pumpSwitch,
                      onChanged: autoMode ? null : _updatePumpSwitch,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: pumpSwitch
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        pumpSwitch ? Icons.check_circle : Icons.info,
                        color: pumpSwitch ? Colors.green : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pumpSwitch
                            ? 'Pump is currently running'
                            : 'Pump is currently off',
                        style: TextStyle(
                          fontSize: 13,
                          color: pumpSwitch ? Colors.green : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                if ((double.tryParse(soilValue) ?? 0) < 26 && !pumpSwitch && autoMode)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Low soil moisture detected. Pump will turn on automatically.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharts() {
    if (soilData.isEmpty) soilData.add(const FlSpot(0, 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Soil Moisture Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: timeLabels.isNotEmpty,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= 0 && value.toInt() < timeLabels.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      timeLabels[value.toInt()],
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 10,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 24,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10,
                                  ),
                                );
                              },
                              reservedSize: 32,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: soilData,
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.withOpacity(0.5),
                                Colors.green,
                              ],
                            ),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.withOpacity(0.1),
                                  Colors.green.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFarmHealth() {
    double soilScore = double.tryParse(soilValue) ?? 0;
    double tempScore = double.tryParse(temperatureValue) ?? 0;
    double humidityScore = double.tryParse(humidityValue) ?? 0;

    soilScore = soilScore > 50 ? 100 : soilScore * 2;
    tempScore = tempScore > 20 && tempScore < 30 ? 100 : 100 - (((tempScore - 25).abs()) * 10);
    tempScore = tempScore.clamp(0, 100);
    humidityScore = humidityScore > 40 && humidityScore < 70 ? 100 : 100 - (((humidityScore - 55).abs()) * 3);
    humidityScore = humidityScore.clamp(0, 100);

    double healthScore = (soilScore + tempScore + humidityScore) / 3;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Farm Health',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: CircularProgressIndicator(
                              value: healthScore / 100,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                healthScore > 80
                                    ? Colors.green
                                    : healthScore > 60
                                    ? Colors.yellow
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${healthScore.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                healthScore > 80
                                    ? 'Excellent'
                                    : healthScore > 60
                                    ? 'Good'
                                    : healthScore > 40
                                    ? 'Fair'
                                    : 'Poor',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
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
              const SizedBox(height: 12),
              _buildHealthRecommendation(healthScore),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthRecommendation(double score) {
    String message;
    IconData icon;
    Color color;

    if (score > 80) {
      message = 'Your farm is in excellent condition! Keep up the good work!';
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (score > 60) {
      message = 'Your farm is in good condition with minor adjustments needed.';
      icon = Icons.thumb_up;
      color = Colors.blue;
    } else if (score > 40) {
      message = 'Your farm needs attention. Consider checking soil moisture and irrigation.';
      icon = Icons.warning;
      color = Colors.orange;
    } else {
      message = 'Critical attention needed! Check your sensors and irrigation system.';
      icon = Icons.error;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}