@RestResource(UrlMapping='/*')
global with sharing class RestRouting {
    private RestRouting() { }

    private static final Integer STATUS_200_OK = 200;
    private static final Integer STATUS_400_BAD_REQUEST = 400;
    private static final Integer STATUS_404_NOT_FOUND = 404;
    private static final Integer STATUS_405_METHOD_NOT_ALLOWED = 405;

    public static final String HTTP_GET = 'GET';
    public static final String HTTP_POST = 'POST';
    public static final String HTTP_PUT = 'PUT';
    public static final String HTTP_PATCH = 'PATCH';
    public static final String HTTP_DELETE = 'DELETE';

    /**
     * RESOURCE METHODS
     */

    @TestVisible
    private static ConfigProvider CONFIGS = new RestRoutingConfigs();

    @HttpGet
    global static void doGet() {
        execute(RestContext.request, RestContext.response);
    }

    @HttpPost
    global static void doPost() {
        execute(RestContext.request, RestContext.response);
    }

    @HttpPut
    global static void doPut() {
        execute(RestContext.request, RestContext.response);
    }

    @HttpPatch
    global static void doPatch() {
        execute(RestContext.request, RestContext.response);
    }

    @HttpDelete
    global static void doDelete() {
        execute(RestContext.request, RestContext.response);
    }

    @TestVisible
    private static void execute(RestRequest request, RestResponse response) {
        Object result;

        // JSON is default content-type
        String contentTypeJson = 'application/json';
        response.headers.put('Content-Type', contentTypeJson);

        try {
            result = new RouteHandler(request, response, new RouteResolver()).handle();
            response.statusCode = STATUS_200_OK;
        }
        catch(HttpException httpExc) {
            response.statusCode = httpExc.statusCode;
            result = makeMessage(httpExc);
        }

        if(response.headers.get('Content-Type') == contentTypeJson) {
            result = JSON.serialize(result);
        }

        response.responseBody = result != null ? Blob.valueOf(String.valueOf(result)) : null;
    }

    private static String makeMessage(Exception e) {
        return
                '# Message: '+ e.getMessage() +
                ' # Line Number: '+ e.getLineNumber() +
                ' # Stacktrace: '+ e.getStackTraceString();
    }

    /**
     * ROUTE HANDLER
     */

    private class RouteHandler {
        private final RestRequest request;
        private final RestResponse response;
        private final RouteResolver routeResolver;

        public RouteHandler(RestRequest request, RestResponse response, RouteResolver routeResolver) {
            this.request = request;
            this.response = response;
            this.routeResolver = routeResolver;
        }

        public Object handle() {
            ResolvedRoute resolvedRoute = this.resolveRoutes();

            if(resolvedRoute == null) {
                resolvedRoute = this.resolveRouteGroups();
            }

            if(resolvedRoute == null) {
                throw404NotFound('route is not defined');
            }

            this.validateIdentifiers(resolvedRoute);

            return this.executeController(resolvedRoute);
        }

        private ResolvedRoute resolveRoutes() {
            ResolvedRoute resolvedRoute;

            for(Route route : CONFIGS.getRoutes()) {
                resolvedRoute = this.routeResolver.resolve(this.request.requestURI, route);
                if(resolvedRoute != null) { break; }
            }

            return resolvedRoute;
        }

        private ResolvedRoute resolveRouteGroups() {
            ResolvedRoute resolvedRoute;

            for(RouteGroupProvider routeGroupProvider : CONFIGS.getRouteGroupProviders()) {
                RouteGroup routeGroup = routeGroupProvider.getRouteGroup();

                for(Route route : routeGroup.routes) {
                    resolvedRoute = this.routeResolver.resolve(this.request.requestURI, route);
                    if(resolvedRoute != null) { break; }
                }

                if(resolvedRoute != null) {
                    this.setIdentifierValidators(resolvedRoute.route, routeGroup);
                }
            }

            return resolvedRoute;
        }

        private void setIdentifierValidators(Route route, RouteGroup routeGroup) {
            if(routeGroup.validatorMap == null) {
                return;
            }

            for(String identifier : routeGroup.validatorMap.keySet()) {
                // favor route validator over route group validator
                if(! route.validatorMap.containsKey(identifier)) {
                    route.validatorMap.put(identifier, routeGroup.validatorMap.get(identifier));
                }
            }
        }

        private void validateIdentifiers(ResolvedRoute resolvedRoute) {
            for(String identifierName : resolvedRoute.identifiers.keySet()) {
                IdentifierValidator validator = resolvedRoute.route.validatorMap.get(identifierName);
                String identifier = resolvedRoute.identifiers.get(identifierName);

                if(validator != null && ! validator.isValid(identifier)) {
                    throw400BadRequest('value ' + identifier + ' for ' + identifierName +' is invalid');
                }
            }
        }

        private Object executeController(ResolvedRoute resolvedRoute) {
            Controller ctrl = resolvedRoute.route.method2Controller.get(this.request.httpMethod);

            if(ctrl == null) {
                throw405MethodNotAllowed();
            }

            return ctrl
                    .request(this.request)
                    .response(this.response)
                    .identifiers(resolvedRoute.identifiers)
                    .execute();
        }
    }

    /**
     * IDENTIFIER VALIDATION BUILDER
     */

    public class IdentifierValidationBuilder {
        private final RouteBuilder routeBuilder;
        private final RouteGroupBuilder routeGroupBuilder;

        private IdentifierValidationBuilder(RouteBuilder routeBuilder) {
            this.routeBuilder = routeBuilder;
        }

        private IdentifierValidationBuilder(RouteGroupBuilder routeGroupBuilder) {
            this.routeGroupBuilder = routeGroupBuilder;
        }

        private final Map<String, IdentifierValidator> validatorMap
                = new Map<String, IdentifierValidator>();

        public IdentifierValidationBuilder whenNumeric(String identifier) {
            this.validatorMap.put(identifier, new NumericValidator());
            return this;
        }

        public IdentifierValidationBuilder whenAlpha(String identifier) {
            this.validatorMap.put(identifier, new AlphaValidator());
            return this;
        }

        public IdentifierValidationBuilder whenAlphanumeric(String identifier) {
            this.validatorMap.put(identifier, new AlphanumericValidator());
            return this;
        }

        public IdentifierValidationBuilder whenSObjectId(String identifier, SObjectType sObjType) {
            this.validatorMap.put(identifier, new SObjectIdValidator(sObjType));
            return this;
        }

        public IdentifierValidationBuilder whenRegex(String identifier, String regex) {
            this.validatorMap.put(identifier, new RegexValidator(regex));
            return this;
        }

        public IdentifierValidationBuilder when(String identifier, IdentifierValidator validator) {
            this.validatorMap.put(identifier, validator);
            return this;
        }

        public RouteBuilder endRouteValidations() {
            this.routeBuilder.route.validatorMap.putAll(this.validatorMap);
            return this.routeBuilder;
        }

        public RouteGroupBuilder endRouteGroupValidations() {
            this.routeGroupBuilder.routeGroup.validatorMap.putAll(this.validatorMap);
            return this.routeGroupBuilder;
        }
    }

    /**
     * ROUTE
     */

    public class Route {
        private String path;
        private final Map<String, Controller> method2Controller = new Map<String, Controller>();
        private final Map<String, IdentifierValidator> validatorMap = new Map<String, IdentifierValidator>();

        private Route() { }
    }

    /**
     * ROUTE GROUP
     */

    public class RouteGroup {
        private String prefix;
        private final List<Route> routes = new List<Route>();
        private final Map<String, IdentifierValidator> validatorMap = new Map<String, IdentifierValidator>();

        private RouteGroup() { }
    }


    /**
     * ROUTE BUILDER
     */

    public class RouteBuilder {
        private final Route route = new Route();
        private final RouteGroupBuilder routeGroupBuilder;

        public RouteBuilder() { }

        private RouteBuilder(String path, RouteGroupBuilder routeGroupBuilder) {
            this.route.path = path;
            this.routeGroupBuilder = routeGroupBuilder;
        }

        public RouteBuilder path(String path) {
            String prefix = this.routeGroupBuilder?.routeGroup.prefix;
            this.route.path = (prefix != null ? prefix : '') + path;
            return this;
        }

        public RouteBuilder onGet(RestRouting.Controller ctrl) {
            this.route.method2Controller.put(HTTP_GET, ctrl);
            return this;
        }

        public RouteBuilder onPost(RestRouting.Controller ctrl) {
            this.route.method2Controller.put(HTTP_POST, ctrl);
            return this;
        }

        public RouteBuilder onPut(RestRouting.Controller ctrl) {
            this.route.method2Controller.put(HTTP_PUT, ctrl);
            return this;
        }

        public RouteBuilder onPatch(RestRouting.Controller ctrl) {
            this.route.method2Controller.put(HTTP_PATCH, ctrl);
            return this;
        }

        public RouteBuilder onDelete(RestRouting.Controller ctrl) {
            this.route.method2Controller.put(HTTP_DELETE, ctrl);
            return this;
        }

        public IdentifierValidationBuilder startRouteValidations() {
            return new IdentifierValidationBuilder(this);
        }

        public RouteGroupBuilder endRoute() {
            this.routeGroupBuilder.routeGroup.routes.add(this.build());
            return this.routeGroupBuilder;
        }

        public Route build() {
            if(String.isBlank(this.route.path)) {
                throw new RoutingException('route path cannot be blank');
            }

            if(this.route.method2Controller.isEmpty()) {
                throw new RoutingException('at least one route controller must be defined');
            }

            return this.route;
        }
    }

    /**
     * ROUTE GROUP BUILDER
     */

    public class RouteGroupBuilder {
        private final RouteGroup routeGroup = new RouteGroup();

        public RouteGroupBuilder() { }

        public RouteGroupBuilder prefix(String prefix) {
            this.routeGroup.prefix = prefix;
            return this;
        }

        public RouteBuilder startRoute(String path) {
            return new RouteBuilder(this.routeGroup.prefix + path, this);
        }

        public IdentifierValidationBuilder startRouteGroupValidations() {
            return new IdentifierValidationBuilder(this);
        }

        public RouteGroup build() {
            System.debug(this.routeGroup);
            if(String.isBlank(this.routeGroup.prefix)) {
                throw new RoutingException('route group prefix cannot be blank');
            }

            if(this.routeGroup.routes.isEmpty()) {
                throw new RoutingException('route group routes cannot be empty');
            }

            return this.routeGroup;
        }
    }

    /**
     * ROUTE RESOLVER
     */

    private class RouteResolver {

        public ResolvedRoute resolve(String fullPath, Route route) {
            if(String.isBlank(route.path)) {
                return null;
            }

            ResolvedRoute result;
            String path = fullPath.substringBefore('?');

            List<Integer> identifierIndexes = this.getIdentifierIndexes(route.path);
            String strippedRoutePath = this.stripPath(route.path, identifierIndexes);
            String strippedPath = this.stripPath(path, identifierIndexes);

            if(strippedRoutePath == strippedPath) {
                result = new ResolvedRoute(route, this.getIdentifiers(path, route.path, identifierIndexes));
            }

            return result;
        }

        private List<Integer> getIdentifierIndexes(String routePath) {
            List<Integer> indexes = new List<Integer>();
            Integer i = 0;

            for(String part : routePath.split('/')) {
                if(String.isNotBlank(part) && part.left(1) == '{') {
                    indexes.add(i);
                }

                i++;
            }

            return indexes;
        }

        private String stripPath(String path, List<Integer> indexes) {
            String strippedPath = path;
            Boolean hasTrailingSlash = strippedPath.right(1) == '/';

            if(indexes.isEmpty()) {
                return strippedPath;
            }

            List<String> parts = path.split('/');
            List<String> remainingParts = new List<String>();

            for(Integer i=0 ; i < parts.size() ; i++) {
                if(! indexes.contains(i)) {
                    remainingParts.add(parts[i]);
                }
                else {
                    remainingParts.add('{}');
                }
            }

            return String.join(remainingParts, '/') + (hasTrailingSlash ? '/' : '');
        }

        private Map<String, String> getIdentifiers(String path, String routePath, List<Integer> indexes) {
            Map<String, String> identifiers = new Map<String, String>();

            if(indexes.isEmpty()) {
                return identifiers;
            }

            List<String> pathParts = path.split('/');
            List<String> routePathParts = routePath.split('/');

            for(Integer index : indexes) {
                String key = routePathParts[index].replaceAll('[\\{\\}]', '');
                String value = pathParts[index];
                identifiers.put(key, value);
            }

            return identifiers;
        }
    }

    private class ResolvedRoute {
        public final Route route;
        public final Map<String, String> identifiers;

        public ResolvedRoute(Route route, Map<String, String> identifiers) {
            this.route = route;
            this.identifiers = identifiers;
        }
    }

    /**
     * CONTROLLER
     */

    public abstract class Controller {
        protected RestRequest request;
        protected RestResponse response;
        protected final Map<String, String> identifiers = new Map<String, String>();

        public Controller() { }

        public Controller request(RestRequest request) {
            this.request = request;
            return this;
        }

        public Controller response(RestResponse response) {
            this.response = response;
            return this;
        }

        public Controller identifiers(Map<String, String> identifiers) {
            this.identifiers.putAll(identifiers);
            return this;
        }

        public abstract Object execute();
    }

    /**
     * IDENTIFIER VALIDATORS
     */

    @TestVisible
    private class RegexValidator implements IdentifierValidator {
        private final String regex;

        public RegexValidator(String regex) {
            this.regex = regex;
        }

        public Boolean isValid(String identifier) {
            return Pattern.matches(regex, identifier);
        }
    }

    @TestVisible
    private class AlphanumericValidator implements IdentifierValidator {
        public Boolean isValid(String identifier) {
            return identifier != null && identifier.isAlphanumeric();
        }
    }

    @TestVisible
    private class AlphaValidator implements IdentifierValidator {
        public Boolean isValid(String variable) {
            return variable != null && variable.isAlpha();
        }
    }

    @TestVisible
    private class NumericValidator implements IdentifierValidator {
        public Boolean isValid(String variable) {
            return variable != null && variable.isNumeric();
        }
    }

    @TestVisible
    private class SObjectIdValidator implements IdentifierValidator {
        private final SObjectType sObjType;

        public SObjectIdValidator(SObjectType sObjType) {
            this.sObjType = sObjType;
        }

        public Boolean isValid(String identifier) {
            Id sObjId;

            try {
                sObjId = Id.valueOf(identifier);
            }
            catch(Exception e) {}

            return sObjId != null && sObjId.getSobjectType() == this.sObjType;
        }
    }

    public interface IdentifierValidator {
        Boolean isValid(String identifier);
    }

    /**
     * CONFIG PROVIDER
     */

    public interface ConfigProvider {
        List<Route> getRoutes();
        List<RouteGroupProvider> getRouteGroupProviders();
    }

    /**
     * ROUTE GROUP PROVIDER
     */

    public interface RouteGroupProvider {
        RouteGroup getRouteGroup();
    }

    /**
     * ROUTING EXCEPTION
     */

    public class RoutingException extends Exception { }

    /**
     * HTTP EXCEPTION
     */

    public static HttpException throw400BadRequest(String message) {
        throw new HttpException(STATUS_400_BAD_REQUEST, message);
    }

    public static HttpException throw404NotFound(String message) {
        throw new HttpException(STATUS_404_NOT_FOUND, message);
    }

    public static HttpException throw405MethodNotAllowed() {
        throw new HttpException(STATUS_405_METHOD_NOT_ALLOWED);
    }

    public class HttpException extends Exception {
        public final Integer statusCode;

        private HttpException(Integer statusCode) {
            this.statusCode = statusCode;
        }

        private HttpException(Integer statusCode, String message) {
            this(statusCode);
            this.setMessage(message);
        }
    }
}