
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000'));
  }

  Stream get stream => _channel.stream;
}
