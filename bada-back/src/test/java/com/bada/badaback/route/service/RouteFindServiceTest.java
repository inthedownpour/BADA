package com.bada.badaback.route.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.route.domain.Route;
import com.bada.badaback.route.exception.RouteErrorCode;
import com.bada.badaback.state.domain.State;
import com.bada.badaback.state.exception.StateErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.RouteFixture.ROUTE1;
import static com.bada.badaback.feature.StateFixture.STATE1;
import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;

class RouteFindServiceTest extends ServiceTest {
    @Autowired
    private RouteFindService routeFindService;
    @Autowired
    private MemberFindService memberFindService;

    private static Member parent;
    private static Member notstart;
    private static Member child;
    private static Route route;

    @BeforeEach
    void setUp(){
        notstart = memberRepository.save(SUNKYOUNG.toMember());
        parent = memberRepository.save(JIYEON.toMember());
        child = memberRepository.save(YONGJUN.toMember());
        route = routeRepository.save(ROUTE1.toRoute(child));
    }

    @Test
    @DisplayName("멤버로 route를 조회한다")
    void findByMember() {
        //when
        Route findRoute = routeFindService.findByMember(child);
        Member not_start = memberFindService.findByEmailAndSocial(notstart.getEmail(), notstart.getSocial());
        Member not_child = memberFindService.findByEmailAndSocial(parent.getEmail(),parent.getSocial());

        //then
        assertThatThrownBy(()->routeFindService.findByMember(not_start))
                .isInstanceOf(BaseException.class)
                .hasMessage(RouteErrorCode.ROUTE_NOT_FOUND.getMessage());

        assertThatThrownBy(()->routeFindService.findByMember(not_child))
                .isInstanceOf(BaseException.class)
                .hasMessage(RouteErrorCode.ROUTE_NOT_FOUND.getMessage());

        assertThat(findRoute).isEqualTo(route);
    }
}