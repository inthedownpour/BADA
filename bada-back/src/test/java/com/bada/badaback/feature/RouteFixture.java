package com.bada.badaback.feature;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.route.domain.Route;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum RouteFixture {
    ROUTE1("36.421518", "127.391538", "36.421914", "127.38412", "null");

    private final String startLatitude;
    private final String startLongitude;

    private final String endLatitude;
    private final String endLongitude;

    private final String pointList;

    public Route toRoute(Member child) {
        return Route.createRoute(startLatitude, startLongitude, endLatitude, endLongitude, pointList, child);
    }
}
