@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
   public HTTPResponse respond(HTTPRequest request) {
      // Create a fake response
      HttpResponse response = new HttpResponse();
      response.setHeader('Content-Type', 'application/json');
      // response.setBody('{"lifespan":0,"cost":300,"sku":"100004"}');
      response.setStatus('error message');
      response.setStatusCode(500);
      return response; 
  }
}