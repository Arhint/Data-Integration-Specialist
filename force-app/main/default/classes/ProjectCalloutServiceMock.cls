@isTest
public class ProjectCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
   public HTTPResponse respond(HTTPRequest request) {
      // Create a fake response
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      response.setBody('{"lifespan":0,"cost":300,"sku":"100004"}');
      response.setStatus('OK');
      response.setStatusCode(201);
      return response; 
  }
}