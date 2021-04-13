import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as router;
import 'package:shelf_static/shelf_static.dart';

const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  var portStr = result['port'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  var app = router.Router();
  app.mount('/api/', apiRouter());
  app.get('/', createStaticHandler('static', defaultDocument: 'index.html'));
  app.get('/assets/<file|.*>', createStaticHandler('static'));

  var handler = const shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(app);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

router.Router apiRouter() {
  final apiApp = router.Router();
  apiApp.get('/', (request) {
    return shelf.Response.ok('Hello.\n');
  });

  apiApp.get('/jsonHandlerExample', (shelf.Request request) {
    return shelf.Response.ok('{"message": "Hello World!"}', headers: {'content-type': 'application/json'});
  });

  apiApp.post('/jsonHandlerExample', (shelf.Request request) async {
    final reqBody = await request.readAsString();
    final body = json.decode(reqBody);
    if (body.keys.contains('name')) {
      var name = body['name'];
      var responseBody = {'message': '$name, you are an avenger now'};
      return shelf.Response.ok(jsonEncode(responseBody), headers: {'content-type': 'application/json'});
    }
    return shelf.Response.forbidden('Please provide a name field in the JSON!!\n');
  });

  apiApp.get('/<file|.*>', createStaticHandler('assets'));

  return apiApp;
}
