@IsTest
private with sharing class RestRouting_T {
    private static final Id ACCOUNT_ID = '001000000000000001';
    private static final String ACCOUNT_NUMBER = 'ABC123';
    private static final String CONTACT_NUMBER = '123';
    private static final String LEAD_NUMBER = 'ABC';
    private static final String CAMPAIGN_NUMBER = 'ABC';
    private static final String CASE_ID = '500000000000000001';
    private static final String CASE_NUMBER = 'ABC';

    // PUT /v1/accounts/

    @IsTest
    private static void accounts_put() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_PUT;
        request.requestURI = '/v1/accounts/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doPut();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"PUT\"', response.responseBody.toString(), 'response body incorrect');
    }

    // DELETE /v1/accounts/{account-id}/

    @IsTest
    private static void accounts_delete() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_DELETE;
        request.requestURI = '/v1/accounts/' + ACCOUNT_ID + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doDelete();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"DELETE\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void accounts_delete_invalidSObjectId() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_DELETE;
        request.requestURI = '/v1/accounts/' + ACCOUNT_NUMBER + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doDelete();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'status code incorrect');
    }

    // PATCH /v1/accounts/{account-id}/

    @IsTest
    private static void accounts_patch() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_PATCH;
        request.requestURI = '/v1/accounts/' + ACCOUNT_ID + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doPatch();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"PATCH\"', response.responseBody.toString(), 'response body incorrect');
    }

    // POST /v1/accounts/{account-number}/contacts/

    @IsTest
    private static void accountsContacts_post() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_POST;
        request.requestURI = '/v1/accounts/' + ACCOUNT_NUMBER + '/contacts/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doPost();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"POST\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void accountsContacts_post_invalidAccountNumber() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_POST;
        request.requestURI = '/v1/accounts/' + ACCOUNT_NUMBER + '-' + '/contacts/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doPost();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'status code incorrect');
    }

    // GET /v1/contacts/{contact-number}/

    @IsTest
    private static void contacts_get() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/contacts/' + CONTACT_NUMBER + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"GET\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void contacts_get_invalidContactNumber() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/contacts/' + CONTACT_NUMBER + 'a' + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'status code incorrect');
    }

    // GET /v1/leads/{lead-number}/

    @IsTest
    private static void leads_get() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/leads/' + LEAD_NUMBER + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"GET\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void leads_get_invalidLeadNumber() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/leads/' + LEAD_NUMBER + '1' + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'status code incorrect');
    }

    // GET /v1/campaigns/{campaign-number}/

    @IsTest
    private static void campaigns_get() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/campaigns/' + CAMPAIGN_NUMBER + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"GET\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void campaigns_get_invalidCampaignNumber() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/leads/' + CAMPAIGN_NUMBER + '1' + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'status code incorrect');
    }

    // GET /v1/cases/{case-id-or-number}/

    @IsTest
    private static void cases_get_caseId() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/campaigns/' + CASE_ID + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"GET\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void cases_get_caseNumber() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/cases/' + CASE_NUMBER + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'status code incorrect');
        System.assertEquals('\"GET\"', response.responseBody.toString(), 'response body incorrect');
    }

    @IsTest
    private static void cases_get_invalidIdentifier() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_GET;
        request.requestURI = '/v1/leads/' + CASE_ID + '1' + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'status code incorrect');
    }


    @IsTest
    private static void methodNotAllowed() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_DELETE;
        request.requestURI = '/v1/cases/' + CASE_NUMBER + '/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(405, response.statusCode, 'status code incorrect');
    }

    @IsTest
    private static void routeNotFound() {
        RestRouting.CONFIGS = new Configs();
        RestRequest request = new RestRequest();
        request.httpMethod = RestRouting.HTTP_DELETE;
        request.requestURI = '/v1/cases/' + CASE_NUMBER + '/foo/';
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        RestRouting.doGet();
        Test.stopTest();

        System.assertEquals(404, response.statusCode, 'status code incorrect');
    }

    @IsTest
    private static void routePathMissing() {
        Test.startTest();

        try {
            new Configs_RoutePathMissing().getRoutes();
            System.assert(false, 'should throw exception');
        }
        catch(Exception e) { }

        Test.stopTest();
    }

    @IsTest
    private static void routeControllerMissing() {
        Test.startTest();

        try {
            new Configs_RouteControllerMissing().getRoutes();
            System.assert(false, 'should throw exception');
        }
        catch(Exception e) { }

        Test.stopTest();
    }

    @IsTest
    private static void routeGroupPrefixMissing() {
        Test.startTest();

        try {
            new Configs_RouteGroupPrefixMissing().getRouteGroupProviders()[0].getRouteGroup();
            System.assert(false, 'should throw exception');
        }
        catch(Exception e) { }

        Test.stopTest();
    }

    @IsTest
    private static void routeGroupRouteMissing() {
        Test.startTest();

        try {
            new Configs_RouteGroupRouteMissing().getRouteGroupProviders()[0].getRouteGroup();
            System.assert(false, 'should throw exception');
        }
        catch(Exception e) { }

        Test.stopTest();
    }

    private class GetCtrl extends RestRouting.Controller {
        public GetCtrl() { super(); }

        public override Object execute() {
            return 'GET';
        }
    }

    private class PostCtrl extends RestRouting.Controller {
        public PostCtrl() { super(); }

        public override Object execute() {
            return 'POST';
        }
    }

    private class PutCtrl extends RestRouting.Controller {
        public PutCtrl() { super(); }

        public override Object execute() {
            return 'PUT';
        }
    }

    private class PatchCtrl extends RestRouting.Controller {
        public PatchCtrl() { super(); }

        public override Object execute() {
            return 'PATCH';
        }
    }

    private class DeleteCtrl extends RestRouting.Controller {
        public DeleteCtrl() { super(); }

        public override Object execute() {
            return 'DELETE';
        }
    }

    public class Configs_RoutePathMissing implements RestRouting.ConfigProvider {

        public List<RestRouting.Route> getRoutes() {
            return new List<RestRouting.Route>{
                    new RestRouting.RouteBuilder().build()
            };
        }

        public List<RestRouting.RouteGroupProvider> getRouteGroupProviders() {
            return new List<RestRouting.RouteGroupProvider>();
        }
    }

    public class Configs_RouteControllerMissing implements RestRouting.ConfigProvider {

        public List<RestRouting.Route> getRoutes() {
            return new List<RestRouting.Route>{
                    new RestRouting.RouteBuilder()
                            .path('/some-path/')
                            .build()
            };
        }

        public List<RestRouting.RouteGroupProvider> getRouteGroupProviders() {
            return new List<RestRouting.RouteGroupProvider>();
        }
    }

    public class Configs_RouteGroupPrefixMissing implements RestRouting.ConfigProvider {

        public List<RestRouting.Route> getRoutes() {
            return new List<RestRouting.Route>();
        }

        public List<RestRouting.RouteGroupProvider> getRouteGroupProviders() {
            return new List<RestRouting.RouteGroupProvider>{
                    new RouteGroup_PrefixMissing()
            };
        }
    }

    public class Configs_RouteGroupRouteMissing implements RestRouting.ConfigProvider {

        public List<RestRouting.Route> getRoutes() {
            return new List<RestRouting.Route>();
        }

        public List<RestRouting.RouteGroupProvider> getRouteGroupProviders() {
            return new List<RestRouting.RouteGroupProvider>{
                    new RouteGroup_RouteMissing()
            };
        }
    }

    private class RouteGroup_PrefixMissing implements RestRouting.RouteGroupProvider {

        public RestRouting.RouteGroup getRouteGroup() {
            return new RestRouting.RouteGroupBuilder().build();
        }
    }

    private class RouteGroup_RouteMissing implements RestRouting.RouteGroupProvider {

        public RestRouting.RouteGroup getRouteGroup() {
            return new RestRouting.RouteGroupBuilder()
                    .prefix('/some-route/')
                    .build();
        }
    }

    public class Configs implements RestRouting.ConfigProvider {
        public List<RestRouting.Route> getRoutes() {
            return new List<RestRouting.Route>{
                    new RestRouting.RouteBuilder()
                            .path('/v1/contacts/{contact-number}/')
                            .onGet(new GetCtrl())
                            .startRouteValidations()
                                .whenNumeric('contact-number')
                            .endRouteValidations()
                            .build(),

                    new RestRouting.RouteBuilder()
                            .path('/v1/leads/{lead-number}/')
                            .onGet(new GetCtrl())
                            .startRouteValidations()
                                .whenAlpha('lead-number')
                            .endRouteValidations()
                            .build(),

                    new RestRouting.RouteBuilder()
                            .path('/v1/campaigns/{campaign-number}/')
                            .onGet(new GetCtrl())
                            .startRouteValidations()
                                .whenRegex('lead-number', '^[A-za-z]+$')
                            .endRouteValidations()
                            .build(),

                    new RestRouting.RouteBuilder()
                            .path('/v1/cases/{case-id-or-number}/')
                            .onGet(new GetCtrl())
                            .startRouteValidations()
                                .when('case-id-or-number', new IsSObjectIdOrAlpha(Case.SObjectType))
                                .whenSObjectId('case-id', Case.SObjectType) // just for coverage
                            .endRouteValidations()
                            .build()
            };
        }

        public List<RestRouting.RouteGroupProvider> getRouteGroupProviders() {
            return new List<RestRouting.RouteGroupProvider>{
                    new AccountsRouteGroupV1()
            };
        }
    }

    public class AccountsRouteGroupV1 implements RestRouting.RouteGroupProvider {

        public RestRouting.RouteGroup getRouteGroup() {
            return new RestRouting.RouteGroupBuilder()
                    .prefix('/v1/accounts')

                    .startRouteGroupValidations()
                        .whenSObjectId('account-id', Account.SObjectType)
                        .when('foo', null)
                        .whenAlpha('foo')
                        .whenRegex('foo', 'foo')
                        .whenNumeric('foo')
                        .whenAlphanumeric('foo')
                    .endRouteGroupValidations()

                    .startRoute('/')
                        .onPut(new PutCtrl())
                    .endRoute()

                    .startRoute('/{account-id}/')
                        .onDelete(new DeleteCtrl())
                        .onPatch(new PatchCtrl())
                    .endRoute()

                    .startRoute('/{account-number}/contacts/')
                        .onPost(new PostCtrl())
                        .startRouteValidations()
                            .whenAlphanumeric('account-number')
                        .endRouteValidations()
                    .endRoute()

                    .build();
        }
    }

    private class IsSObjectIdOrAlpha implements RestRouting.IdentifierValidator {
        private final SObjectType sObjType;

        public IsSObjectIdOrAlpha(SObjectType sObjType) {
            this.sObjType = sObjType;
        }

        public Boolean isValid(String identifier) {
            Boolean isSObjectId = new RestRouting.SObjectIdValidator(sObjType).isValid(identifier);
            return String.isNotBlank(identifier) && (identifier.isAlpha() || isSObjectId);
        }
    }



    @IsTest
    private static void identifierValidator_regex() {
        String regex = '^[a-z]+$';
        System.assert(! new RestRouting.RegexValidator(regex).isValid('ABC'));
        System.assert(new RestRouting.RegexValidator(regex).isValid('abc'));
    }

    @IsTest
    private static void identifierValidator_alpha() {
        System.assert(! new RestRouting.AlphaValidator().isValid('123'));
        System.assert(new RestRouting.AlphaValidator().isValid('abc'));
    }

    @IsTest
    private static void identifierValidator_numeric() {
        System.assert(! new RestRouting.NumericValidator().isValid('abc'));
        System.assert(new RestRouting.NumericValidator().isValid('123'));
    }

    @IsTest
    private static void identifierValidator_alphanumeric() {
        System.assert(! new RestRouting.AlphanumericValidator().isValid('123abc-'));
        System.assert(new RestRouting.AlphanumericValidator().isValid('123abc'));
    }

    @IsTest
    private static void identifierValidator_sObjectId() {
        String accountId = '001000000000000001';
        System.assert(! new RestRouting.SObjectIdValidator(Account.SObjectType).isValid(accountId+'A'));
        System.assert(new RestRouting.SObjectIdValidator(Account.SObjectType).isValid(accountId));
    }
}