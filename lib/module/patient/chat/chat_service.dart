import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  late PusherChannelsFlutter pusher;

  Future<void> initPusher(String chatId) async {
    pusher = PusherChannelsFlutter.getInstance();

    await pusher.init(
      apiKey: '94d2398297812341c099',
      cluster: 'ap2',
      onConnectionStateChange: onConnectionStateChange,
      onError: onError,
    );

    await pusher.subscribe(
      channelName: 'chat',
      onEvent: onEvent,
    );

    await pusher.connect();
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection state changed: $currentState");
  }

  void onError(String message, dynamic code, dynamic exception) {
    print("Error: $message, Code: $code, Exception: $exception");
  }

  void onEvent(PusherEvent event) {
    // Handle received message here
    print("Received event: ${event.data}");
  }

  void disconnect() {
    pusher.disconnect();
  }
}
