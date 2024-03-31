package com.bada.badaback.feature;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.route.domain.Route;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum RouteFixture {
    ROUTE1("36.421518", "127.391538", "36.421914", "127.38412", "출발지","도착 장소!" ,"36.421583097295446, 127.39135163833407_36.420735963813776, 127.39088503650011_36.420552649750135, 127.39078782797036_36.42103867831523, 127.38927683888134_36.42139139509171, 127.3881185996255_36.42165246217095, 127.3873242191837_36.42188021657534, 127.38747697708666_36.42305787145102, 127.38815188460838_36.42316341042176, 127.38789912658349_36.42359390056029, 127.3869936403651_36.42384108518034, 127.38647145815851_36.423846637827786, 127.3863436916672_36.42249399880221, 127.38543269893229_36.42248844427805, 127.38545491931659_36.42230513001807, 127.38534660067013_36.42266340092529, 127.38414392080257_36.4216885018389, 127.38353844598625_36.42145520461359, 127.3840661828719_36.4216885018389, 127.38353844598625_36.42205513055606, 127.38376619339658");

    private final String startLatitude;
    private final String startLongitude;

    private final String endLatitude;
    private final String endLongitude;

    private final String addressName;

    private final String placeName;

    private final String pointList;

    public Route toRoute(Member child) {
        return Route.createRoute(startLatitude, startLongitude, endLatitude, endLongitude, pointList, addressName, placeName, child);
    }
}
