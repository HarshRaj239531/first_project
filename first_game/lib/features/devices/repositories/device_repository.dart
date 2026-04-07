import '../../../core/models/api_response.dart';
import '../../../core/services/api_client.dart';
import '../models/device_model.dart';

/// Contract for Device operations
abstract class IDeviceRepository {
  Future<ApiResponse<List<Device>>> getDevices();
  Future<ApiResponse<Device>> addDevice(Device device);
  Future<ApiResponse<void>> toggleDevice(String deviceId);
  Future<ApiResponse<void>> removeDevice(String deviceId);
}

/// Real implementation using ApiClient
class RealDeviceRepository implements IDeviceRepository {
  final ApiClient _apiClient;

  RealDeviceRepository(this._apiClient);

  @override
  Future<ApiResponse<List<Device>>> getDevices() async {
    final response = await _apiClient.get('/devices');
    if (response['success'] == true) {
      final devices = (response['data'] as List)
          .map((d) => Device.fromJson(d))
          .toList();
      return ApiResponse.success(devices);
    }
    return ApiResponse.error(response['error'] ?? 'Failed to fetch devices');
  }

  @override
  Future<ApiResponse<Device>> addDevice(Device device) async {
    final response = await _apiClient.post('/devices', device.toJson());
    if (response['success'] == true) {
      return ApiResponse.success(Device.fromJson(response['data']));
    }
    return ApiResponse.error(response['error'] ?? 'Failed to add device');
  }

  @override
  Future<ApiResponse<void>> toggleDevice(String deviceId) async {
    final response = await _apiClient.post('/devices/$deviceId/toggle', {});
    if (response['success'] == true) {
      return ApiResponse.success(null);
    }
    return ApiResponse.error(response['error'] ?? 'Failed to toggle device');
  }

  @override
  Future<ApiResponse<void>> removeDevice(String deviceId) async {
    final response = await _apiClient.delete('/devices/$deviceId');
    if (response['success'] == true) {
      return ApiResponse.success(null);
    }
    return ApiResponse.error(response['error'] ?? 'Failed to remove device');
  }
}

/// Mock implementation for development without a backend
class MockDeviceRepository implements IDeviceRepository {
  final List<Device> _mockDevices = [
    Device(id: 'd1', name: 'Living Room Light', type: DeviceType.light, isOn: true, room: 'Living Room'),
    Device(id: 'd2', name: 'Ceiling Fan', type: DeviceType.fan, isOn: false, room: 'Bedroom'),
    Device(id: 'd3', name: 'Air Conditioner', type: DeviceType.ac, isOn: true, room: 'Bedroom'),
    Device(id: 'd4', name: 'Smart TV', type: DeviceType.tv, isOn: false, room: 'Living Room'),
    Device(id: 'd5', name: 'Front Camera', type: DeviceType.camera, isOn: true, room: 'Entrance'),
    Device(id: 'd6', name: 'Front Door Lock', type: DeviceType.lock, isOn: false, room: 'Entrance'),
    Device(id: 'd7', name: 'Kitchen Speaker', type: DeviceType.speaker, isOn: false, room: 'Kitchen'),
    Device(id: 'd8', name: 'Smart Thermostat', type: DeviceType.thermostat, isOn: true, room: 'Living Room'),
  ];

  @override
  Future<ApiResponse<List<Device>>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ApiResponse.success(List.from(_mockDevices));
  }

  @override
  Future<ApiResponse<Device>> addDevice(Device device) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockDevices.add(device);
    return ApiResponse.success(device);
  }

  @override
  Future<ApiResponse<void>> toggleDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockDevices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _mockDevices[index].isOn = !_mockDevices[index].isOn;
      return ApiResponse.success(null);
    }
    return ApiResponse.error('Device not found');
  }

  @override
  Future<ApiResponse<void>> removeDevice(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDevices.removeWhere((d) => d.id == deviceId);
    return ApiResponse.success(null);
  }
}
