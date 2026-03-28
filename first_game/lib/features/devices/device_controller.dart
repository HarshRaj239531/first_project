import 'package:flutter/material.dart';
import 'models/device_model.dart';

class DeviceController extends ChangeNotifier {
  final List<Device> _devices = [
    Device(id: 'd1', name: 'Living Room Light', type: DeviceType.light, isOn: true, room: 'Living Room'),
    Device(id: 'd2', name: 'Ceiling Fan', type: DeviceType.fan, isOn: false, room: 'Bedroom'),
    Device(id: 'd3', name: 'Air Conditioner', type: DeviceType.ac, isOn: true, room: 'Bedroom'),
    Device(id: 'd4', name: 'Smart TV', type: DeviceType.tv, isOn: false, room: 'Living Room'),
    Device(id: 'd5', name: 'Front Camera', type: DeviceType.camera, isOn: true, room: 'Entrance'),
    Device(id: 'd6', name: 'Front Door Lock', type: DeviceType.lock, isOn: false, room: 'Entrance'),
    Device(id: 'd7', name: 'Kitchen Speaker', type: DeviceType.speaker, isOn: false, room: 'Kitchen'),
    Device(id: 'd8', name: 'Smart Thermostat', type: DeviceType.thermostat, isOn: true, room: 'Living Room'),
  ];

  List<Device> get devices => List.unmodifiable(_devices);

  int get onlineCount => _devices.where((d) => d.isOn).length;

  List<Device> get activeDevices => _devices.where((d) => d.isOn).toList();

  List<String> get rooms =>
      _devices.map((d) => d.room).toSet().toList()..sort();

  List<Device> devicesByRoom(String room) =>
      _devices.where((d) => d.room == room).toList();

  void toggleDevice(String id) {
    final idx = _devices.indexWhere((d) => d.id == id);
    if (idx != -1) {
      _devices[idx].isOn = !_devices[idx].isOn;
      notifyListeners();
    }
  }

  void turnAllOff() {
    for (final d in _devices) {
      d.isOn = false;
    }
    notifyListeners();
  }

  void turnAllOn() {
    for (final d in _devices) {
      d.isOn = true;
    }
    notifyListeners();
  }

  void addDevice(Device device) {
    _devices.add(device);
    notifyListeners();
  }

  void removeDevice(String id) {
    _devices.removeWhere((d) => d.id == id);
    notifyListeners();
  }
}