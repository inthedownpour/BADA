package com.bada.badaback.route.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.route.dto.RouteResponseDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;

import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.RouteFixture.ROUTE1;
import static org.junit.jupiter.api.Assertions.*;

class RouteSearchServiceTest extends ServiceTest {
    @Autowired
    private RouteSearchService routeSearchService;

    private static Member child;

    @BeforeEach
    void setUp() {
        child = memberRepository.save(YONGJUN.toMember());
    }

    @Test
    void searchRoute() throws IOException {
        //when
        child = memberRepository.save(YONGJUN.toMember());
        RouteResponseDto responseDto = routeSearchService.searchRoute(child.getId(),"36.421518","127.391538","36.421914","127.38412",ROUTE1.getAddressName(),ROUTE1.getPlaceName());
        System.out.println(responseDto);
        //then
        assertAll(
                () -> assertEquals(ROUTE1.getStartLatitude(), String.valueOf(responseDto.startLat())),
                () -> assertEquals(ROUTE1.getStartLongitude(), String.valueOf(responseDto.startLng())),
                () -> assertEquals(ROUTE1.getEndLatitude(), String.valueOf(responseDto.endLat())),
                () -> assertEquals(ROUTE1.getEndLongitude(), String.valueOf(responseDto.endLng())),
                ()-> assertEquals(ROUTE1.getAddressName(), responseDto.addressName()),
                ()->assertEquals(ROUTE1.getPlaceName(),responseDto.placeName()));
    }
}