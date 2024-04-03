package com.bada.badaback.route.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.myplace.domain.MyPlace;
import com.bada.badaback.myplace.service.MyPlaceFindService;
import com.bada.badaback.myplace.service.MyPlaceService;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.dto.RoutePlaceResponseDto;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.route.exception.RouteErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.MyPlaceFixture.MYPLACE_0;
import static com.bada.badaback.feature.RouteFixture.ROUTE1;
import static com.bada.badaback.feature.RouteFixture.ROUTE2;
import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;

class RouteServiceTest extends ServiceTest {
    @Autowired
    private RouteFindService routeFindService;

    @Autowired
    private RouteService routeService;

    @Autowired
    private MyPlaceFindService myPlaceService;

    private static Member parent;
    private static Member stranger;
    private static Member child;
    private static Route route;
    private static MyPlace myPlace;


    @BeforeEach
    void setUp() {
        stranger = memberRepository.save(HWIWON.toMember());
        parent = memberRepository.save(JIYEON.toMember());
        child = memberRepository.save(YONGJUN.toMember());
        route = routeRepository.save(ROUTE2.toRoute(child));
        myPlace = myPlaceRepository.save(MYPLACE_0.toMyPlace(child.getFamilyCode()));
    }

    @Test
    void createRoute() {
        //then
        Route findRoute = routeFindService.findByMember(child);
        assertAll(
                () -> assertEquals(ROUTE2.getStartLatitude(), findRoute.getStartLatitude()),
                () -> assertEquals(ROUTE2.getStartLongitude(), findRoute.getStartLongitude()),
                () -> assertEquals(ROUTE2.getEndLatitude(), findRoute.getEndLatitude()),
                () -> assertEquals(ROUTE2.getEndLongitude(), findRoute.getEndLongitude()),
                () -> assertEquals(ROUTE2.getPointList(), findRoute.getPointList()),
                () -> assertEquals(child.getId(), findRoute.getMember().getId())
        );
    }

    @Test
    void getRoute() {
        //when
        RoutePlaceResponseDto responseDto = routeService.getRoute(parent.getId(), child.getId());
        //then
        assertAll(
                () -> assertEquals(ROUTE2.getStartLatitude(), String.valueOf(responseDto.startLat())),
                () -> assertEquals(ROUTE2.getStartLongitude(), String.valueOf(responseDto.startLng())),
                () -> assertEquals(ROUTE2.getEndLatitude(), String.valueOf(responseDto.endLat())),
                () -> assertEquals(ROUTE2.getEndLongitude(), String.valueOf(responseDto.endLng()))
//                () -> assertEquals(ROUTE1.getPointList(), String.valueOf(responseDto.pointList()))
        );
    }
    @Test
    void strangerFindStateByMemberId() {
        //then
        assertThatThrownBy(()->routeService.getRoute(stranger.getId(), child.getId()))
                .isInstanceOf(BaseException.class).hasMessage(RouteErrorCode.NOT_FAMILY.getMessage());
    }

    @Test
    void deleteRoute() {
        //when
        routeService.deleteRoute(child.getId());
        //then
        assertThatThrownBy(() -> routeFindService.findByMember(child)).isInstanceOf(BaseException.class).hasMessage(RouteErrorCode.ROUTE_NOT_FOUND.getMessage());
    }
}