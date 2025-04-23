import 'package:flutter/material.dart';

class HardwareComponentsPage extends StatelessWidget {
  const HardwareComponentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hardware Components'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Connection Diagram:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    // ESP32 Microcontroller
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.memory, size: 80, color: Colors.green),
                          const Text('ESP32 Microcontroller',
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                          const SizedBox(height: 10),
                          // GPIO Pins
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPin('GND', Colors.black),
                              _buildPin('3.3V', Colors.red),
                              _buildPin('GPIO 32', Colors.blue),
                              _buildPin('GPIO 33', Colors.blue),
                              _buildPin('GPIO 25', Colors.blue),
                              _buildPin('GPIO 26', Colors.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Sensors Section
                    SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Soil Moisture Sensor
                          _buildSensorConnection(
                            icon: Icons.water_drop,
                            name: 'Soil Moisture\nSensor',
                            pin: 'GPIO 32 (Analog)',
                            color: Colors.blue,
                          ),

                          // DHT22 Sensor
                          _buildSensorConnection(
                            icon: Icons.device_thermostat,
                            name: 'DHT22\n(Temp/Humidity)',
                            pin: 'GPIO 33 (Digital)',
                            color: Colors.orange,
                          ),

                          // LDR Sensor
                          _buildSensorConnection(
                            icon: Icons.light_mode,
                            name: 'LDR\n(Light Sensor)',
                            pin: 'GPIO 25 (Analog)',
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Power Connections
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('Power Supply',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                            SizedBox(height: 10),
                            Icon(Icons.battery_charging_full, size: 50,color: Colors.black,),
                            Text('12V Power\nSupply',style: TextStyle(color: Colors.black),),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Actuators Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Relay Module
                        _buildActuatorConnection(
                          icon: Icons.electric_bolt,
                          name: 'Relay Module',
                          pin: 'GPIO 26 (Digital)',
                          color: Colors.red,
                        ),

                        // Water Pump
                        _buildActuatorConnection(
                          icon: Icons.opacity,
                          name: 'Water Pump',
                          pin: 'Connected to Relay',
                          color: Colors.blue,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Connection Notes
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Connection Notes:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('• All sensors share common GND and 3.3V power from ESP32'),
                          Text('• DHT22 requires pull-up resistor (often built into modules)'),
                          Text('• Relay controls 12V power to water pump'),
                          Text('• ESP32 can be powered via USB or separate 5V supply'),
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

  Widget _buildPin(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10,color: Colors.black)),
      ],
    );
  }

  Widget _buildSensorConnection({
    required IconData icon,
    required String name,
    required String pin,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 8),
          Text(name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black)),
          const SizedBox(height: 8),
          Text(pin,
              style: TextStyle(fontSize: 10, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildActuatorConnection({
    required IconData icon,
    required String name,
    required String pin,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black)),
          const SizedBox(height: 8),
          Text(pin,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}