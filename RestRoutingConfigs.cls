public with sharing class RestRoutingConfigs implements RestRouting.ConfigProvider {

    public List<RestRouting.Route> getRoutes() {
        return new List<RestRouting.Route>{ };
    }

    public List<RestRouting.RouteGroupProvider> getRouteGroupProviders() {
        return new List<RestRouting.RouteGroupProvider>{ };
    }
}