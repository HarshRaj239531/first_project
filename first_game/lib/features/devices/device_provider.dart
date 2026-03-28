import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'models/device_model.dart';

final deviceProvider = StateNotifierProvider<DeviceNotifier, List<Device>>((ref) {
  return DeviceNotifier();
});

class DeviceNotifier extends StateNotifier<List<Device>> {
  DeviceNotifier() : super([
    Device(id: 'd1', name: 'Living Room Light', type: DeviceType.light, isOn: true, room: 'Living Room', brightness: 0.9, color: Colors.amber),
    Device(id: 'd2', name: 'Ceiling Fan', type: DeviceType.fan, isOn: false, room: 'Bedroom', speed: 1),
    Device(id: 'd3', name: 'Air Conditioner', type: DeviceType.ac, isOn: true, room: 'Bedroom', temperature: 21.0),
    Device(id: 'd4', name: 'Smart TV', type: DeviceType.tv, isOn: false, room: 'Living Room'),
    Device(id: 'd5', name: 'Front Camera', type: DeviceType.camera, isOn: true, room: 'Entrance'),
    Device(id: 'd6', name: 'Front Door Lock', type: DeviceType.lock, isOn: false, room: 'Entrance'),
    Device(id: 'd7', name: 'Kitchen Speaker', type: DeviceType.speaker, isOn: false, room: 'Kitchen'),
    Device(id: 'd8', name: 'Smart Thermostat', type: DeviceType.thermostat, isOn: true, room: 'Living Room', temperature: 23.5),
  ]);

  void toggleDevice(String id) {
    state = [
      for (final device in state)
        if (device.id == id) device.copyWith(isOn: !device.isOn) else device,
    ];
  }

  void updateDevice(Device updatedDevice) {
    state = [
      for (final device in state)
        if (device.id == updatedDevice.id) updatedDevice else device,
    ];
  }

  void updateAttribute(String id, {double? brightness, double? temperature, int? speed, Color? color, bool? isOn}) {
    state = [
      for (final device in state)
        if (device.id == id)
          device.copyWith(
            brightness: brightness,
            temperature: temperature,
            speed: speed,
            color: color,
            isOn: isOn,
          )
        else
          device,
    ];
  }

  int get onlineCount => state.where((d) => d.isOn).length;

  List<String> get rooms => state.map((d) => d.room).toSet().toList()..sort();
}
