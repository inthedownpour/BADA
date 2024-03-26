package com.bada.badaback.route.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.dto.RouteResponseDto;
import com.bada.badaback.route.exception.RouteErrorCode;
import com.bada.badaback.state.exception.StateErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.RouteFixture.ROUTE1;
import static com.bada.badaback.feature.StateFixture.STATE1;
import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;

class RouteServiceTest extends ServiceTest {
    @Autowired
    private RouteFindService routeFindService;

    @Autowired
    private RouteService routeService;

    private static Member parent;
    private static Member stranger;
    private static Member child;
    private static Route route;


    @BeforeEach
    void setUp() {
        stranger = memberRepository.save(HWIWON.toMember());
        parent = memberRepository.save(JIYEON.toMember());
        child = memberRepository.save(YONGJUN.toMember());
        route = routeRepository.save(ROUTE1.toRoute(child));
    }

    @Test
    void createRoute() {
        //then
        Route findRoute = routeFindService.findByMember(child);
        assertAll(
                () -> assertEquals(ROUTE1.getStartLatitude(), findRoute.getStartLatitude()),
                () -> assertEquals(ROUTE1.getStartLongitude(), findRoute.getStartLongitude()),
                () -> assertEquals(ROUTE1.getEndLatitude(), findRoute.getEndLatitude()),
                () -> assertEquals(ROUTE1.getEndLongitude(), findRoute.getEndLongitude()),
                () -> assertEquals(ROUTE1.getPointList(), findRoute.getPointList()),
                () -> assertEquals(child.getId(), findRoute.getMember().getId())
        );
    }

    @Test
    void getRoute() {
        //when
        RouteResponseDto responseDto = routeService.getRoute(parent.getId(), child.getId());
        //then
        assertAll(
                () -> assertEquals(ROUTE1.getStartLatitude(), String.valueOf(responseDto.startLat())),
                () -> assertEquals(ROUTE1.getStartLongitude(), String.valueOf(responseDto.startLng())),
                () -> assertEquals(ROUTE1.getEndLatitude(), String.valueOf(responseDto.endLat())),
                () -> assertEquals(ROUTE1.getEndLongitude(), String.valueOf(responseDto.endLng())),
                () -> assertEquals(ROUTE1.getPointList(), String.valueOf(responseDto.pointList()))
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