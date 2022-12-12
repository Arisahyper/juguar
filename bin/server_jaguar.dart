import 'dart:async' show Future;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class Service {
  Handler get handler {
    final router = Router();

    router.get('/', (Request request) {
      return Response.ok('Get request');
    });

    router.get('/<id>', (Request request, String id) {
      return Response.ok('path parameter $id');
    });

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final params = Uri.splitQueryString(body);
      return Response.ok(params['msg']);
    });

    router.patch('/', (Request request) {
      return Response.ok('patch request');
    });

    router.put('/', (Request request) {
      return Response.ok('put request');
    });

    router.get('/delay', (Request request) async {
      await Future.delayed(Duration(milliseconds: 100));
      return Response.ok('_o/');
    });

    router.mount('/api/', Api().router);

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }
}

class Api {
  Future<Response> _messages(Request request) async {
    return Response.ok('[]');
  }

  Router get router {
    final router = Router();
    router.get('/messages', _messages);
    router.get('/messages/', _messages);
    router.all('/<ignored|.*>', (Request request) => Response.notFound('null'));

    return router;
  }
}

void main() async {
  final service = Service();
  final server = await shelf_io.serve(service.handler, 'localhost', 8080);
  print('Server running on localhost:${server.port}');
}
