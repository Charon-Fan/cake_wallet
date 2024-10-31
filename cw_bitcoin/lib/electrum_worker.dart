import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:cw_bitcoin/electrum_worker/electrum_worker_methods.dart';
// import 'package:cw_bitcoin/electrum_balance.dart';
import 'package:cw_bitcoin/electrum_worker/electrum_worker_params.dart';

class ElectrumWorker {
  final SendPort sendPort;
  ElectrumApiProvider? _electrumClient;

  ElectrumWorker._(this.sendPort, {ElectrumApiProvider? electrumClient})
      : _electrumClient = electrumClient;

  static void run(SendPort sendPort) {
    final worker = ElectrumWorker._(sendPort);
    final receivePort = ReceivePort();

    sendPort.send(receivePort.sendPort);

    receivePort.listen(worker.handleMessage);
  }

  void _sendResponse(ElectrumWorkerResponse response) {
    sendPort.send(jsonEncode(response.toJson()));
  }

  void _sendError(ElectrumWorkerErrorResponse response) {
    sendPort.send(jsonEncode(response.toJson()));
  }

  void handleMessage(dynamic message) async {
    print("Worker: received message: $message");

    try {
      Map<String, dynamic> messageJson;
      if (message is String) {
        messageJson = jsonDecode(message) as Map<String, dynamic>;
      } else {
        messageJson = message as Map<String, dynamic>;
      }
      final workerMethod = messageJson['method'] as String;

      switch (workerMethod) {
        case ElectrumWorkerMethods.connectionMethod:
          await _handleConnect(ElectrumWorkerConnectRequest.fromJson(messageJson));
          break;
        // case 'blockchain.headers.subscribe':
        //   await _handleHeadersSubscribe();
        //   break;
        // case 'blockchain.scripthash.get_balance':
        //   await _handleGetBalance(message);
        //   break;
        case 'blockchain.scripthash.get_history':
          // await _handleGetHistory(workerMessage);
          break;
        case 'blockchain.scripthash.listunspent':
          // await _handleListUnspent(workerMessage);
          break;
        // Add other method handlers here
        // default:
        //   _sendError(workerMethod, 'Unsupported method: ${workerMessage.method}');
      }
    } catch (e, s) {
      print(s);
      _sendError(ElectrumWorkerErrorResponse(error: e.toString()));
    }
  }

  Future<void> _handleConnect(ElectrumWorkerConnectRequest request) async {
    _electrumClient = ElectrumApiProvider(
      await ElectrumTCPService.connect(
        request.uri,
        onConnectionStatusChange: (status) {
          _sendResponse(ElectrumWorkerConnectResponse(status: status.toString()));
        },
        defaultRequestTimeOut: const Duration(seconds: 5),
        connectionTimeOut: const Duration(seconds: 5),
      ),
    );
  }

  // Future<void> _handleHeadersSubscribe() async {
  //   final listener = _electrumClient!.subscribe(ElectrumHeaderSubscribe());
  //   if (listener == null) {
  //     _sendError('blockchain.headers.subscribe', 'Failed to subscribe');
  //     return;
  //   }

  //   listener((event) {
  //     _sendResponse('blockchain.headers.subscribe', event);
  //   });
  // }

  // Future<void> _handleGetBalance(ElectrumWorkerRequest message) async {
  //   try {
  //     final scriptHash = message.params['scriptHash'] as String;
  //     final result = await _electrumClient!.request(
  //       ElectrumGetScriptHashBalance(scriptHash: scriptHash),
  //     );

  //     final balance = ElectrumBalance(
  //       confirmed: result['confirmed'] as int? ?? 0,
  //       unconfirmed: result['unconfirmed'] as int? ?? 0,
  //       frozen: 0,
  //     );

  //     _sendResponse(message.method, balance.toJSON());
  //   } catch (e, s) {
  //     print(s);
  //     _sendError(message.method, e.toString());
  //   }
  // }

  // Future<void> _handleGetHistory(ElectrumWorkerMessage message) async {
  //   try {
  //     final scriptHash = message.params['scriptHash'] as String;
  //     final result = await electrumClient.getHistory(scriptHash);
  //     _sendResponse(message.method, jsonEncode(result));
  //   } catch (e) {
  //     _sendError(message.method, e.toString());
  //   }
  // }

  // Future<void> _handleListUnspent(ElectrumWorkerMessage message) async {
  //   try {
  //     final scriptHash = message.params['scriptHash'] as String;
  //     final result = await electrumClient.listUnspent(scriptHash);
  //     _sendResponse(message.method, jsonEncode(result));
  //   } catch (e) {
  //     _sendError(message.method, e.toString());
  //   }
  // }
}
