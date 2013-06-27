from wsgiref.simple_server import make_server
#import learning_s01

def application(environ, start_response):
    response_body = ['%s: %s' % (key, value) for key, value in sorted(environ.items())]
    response_body = "\n".join(response_body)
    
    status = "200 OK"
    response_headers = [('Content-Type', 'text/plain'), ('Content-Length', str(len(response_body)))]
    start_response(status, response_headers);
    
    return [response_body];

print(__name__ + " started")
httpd = make_server('localhost', 8051, application)
httpd.handle_request()
#httpd.serve_forever()