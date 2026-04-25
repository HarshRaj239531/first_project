import '../../../core/models/api_response.dart';
import '../../../core/services/api_client.dart';
import '../models/device_model.dart';

/// Contract for Device operations.
abstract class IDeviceRepository {
  Future<ApiResponse<List<Device>>> getDevices();
  Future<ApiResponse<Device>> addDevice(Device device);
  Future<ApiResponse<void>> toggleDevice(String deviceId);
  Future<ApiResponse<void>> removeDevice(String deviceId);
}

/// Real implementation that communicates with the Slick Sync Flask backend.
class RealDeviceRepository implements IDeviceRepository {
  final ApiClient _apiClient = ApiClient();

  // Mapping Flutter Device IDs to Flask Endpoints
  final Map<String, String> _deviceMapping = {
    'd1': 'rock',
    'd2': 'fan',
    'd3': 'moon',
    'd4': 'dog',
  };

  @override
  Future<ApiResponse<List<Device>>> getDevices() async {
    try {
      final response = await _apiClient.get('/status');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        
        // We start with our base list of 4 controllable devices
        final List<Device> devices = [
          Device(id: 'd1', name: 'Rock Light', type: DeviceType.light, isOn: data['rock'] ?? false, room: 'Living Room'),
          Device(id: 'd2', name: 'Ceiling Fan', type: DeviceType.fan, isOn: data['fan'] ?? false, room: 'Bedroom'),
          Device(id: 'd3', name: 'Moon Light', type: DeviceType.light, isOn: data['moon'] ?? false, room: 'Bedroom'),
          Device(id: 'd4', name: 'Dog Light', type: DeviceType.light, isOn: data['dog'] ?? false, room: 'Living Room'),
        ];
        
        return ApiResponse.success(devices);
      }
      return ApiResponse.error('Failed to load status');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  @override
  Future<ApiResponse<void>> toggleDevice(String deviceId) async {
    try {
      final endpoint = _deviceMapping[deviceId];
      if (endpoint == null) return ApiResponse.error('Device not mapped to backend');

      // First get current status to know if we are turning on or off
      final statusRes = await _apiClient.get('/status');
      final bool currentState = statusRes.data[endpoint] ?? false;
      final action = currentState ? 'off' : 'on';

      final response = await _apiClient.get('/$endpoint/$action');
      if (response.statusCode == 200) {
        return ApiResponse.success(null);
      }
      return ApiResponse.error('Failed to toggle device');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  @override
  Future<ApiResponse<Device>> addDevice(Device device) async {
    // Backend is currently static, so we just simulate adding
    return ApiResponse.success(device);
  }

  @override
  Future<ApiResponse<void>> removeDevice(String deviceId) async {
    // Backend is currently static
    return ApiResponse.success(null);
  }
}

/// Mock implementation for development without a backend.
class MockDeviceRepository implements IDeviceRepository {
  final List<Device> _mockDevices = [
    Device(id: 'd1', name: 'Living Room Light (Mock)', type: DeviceType.light, isOn: true, room: 'Living Room'),
    Device(id: 'd2', name: 'Ceiling Fan (Mock)', type: DeviceType.fan, isOn: false, room: 'Bedroom'),
    Device(id: 'd3', name: 'Air Conditioner (Mock)', type: DeviceType.ac, isOn: true, room: 'Bedroom'),
    Device(id: 'd4', name: 'Smart TV (Mock)', type: DeviceType.tv, isOn: false, room: 'Living Room'),
  ];

  @override
  Future<ApiResponse<List<Device>>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ApiResponse.success(List.from(_mockDevices));
  }

  @override
  Future<ApiResponse<Device>> addDevice(Device device) async {
    _mockDevices.add(device);
    return ApiResponse.success(device);
  }

  @override
  Future<ApiResponse<void>> toggleDevice(String deviceId) async {
    final index = _mockDevices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _mockDevices[index].isOn = !_mockDevices[index].isOn;
      return ApiResponse.success(null);
    }
    return ApiResponse.error('Device not found');
  }

  @override
  Future<ApiResponse<void>> removeDevice(String deviceId) async {
    _mockDevices.removeWhere((d) => d.id == deviceId);
    return ApiResponse.success(null);
  }
}
