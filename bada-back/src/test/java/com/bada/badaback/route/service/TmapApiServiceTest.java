package com.bada.badaback.route.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.feature.SafeFacilityFixture;
import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.domain.SafeFacility;
import com.bada.badaback.safefacility.domain.Type;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TmapApiServiceTest extends ServiceTest {
    @Autowired
    private TmapApiService tmapApiService;

    @Test
    void getPoint() throws IOException {

        //given
        SafeFacility cctv1 = SafeFacility.createSafeFaciclity(SafeFacilityFixture.CCTV1.getFacilityLatitude(), SafeFacilityFixture.CCTV1.getFacilityLongitude(), Type.CCTV);
        safeFacilityRepository.save(cctv1);
        SafeFacility cctv2 = SafeFacility.createSafeFaciclity(SafeFacilityFixture.CCTV2.getFacilityLatitude(), SafeFacilityFixture.CCTV2.getFacilityLongitude(), Type.CCTV);
        safeFacilityRepository.save(cctv2);
        SafeFacility cctv3 = SafeFacility.createSafeFaciclity(SafeFacilityFixture.CCTV3.getFacilityLatitude(), SafeFacilityFixture.CCTV3.getFacilityLongitude(), Type.CCTV);
        safeFacilityRepository.save(cctv3);
        SafeFacility cctv4 = SafeFacility.createSafeFaciclity(SafeFacilityFixture.CCTV4.getFacilityLatitude(), SafeFacilityFixture.CCTV4.getFacilityLongitude(), Type.CCTV);
        safeFacilityRepository.save(cctv4);
        SafeFacility cctv5 = SafeFacility.createSafeFaciclity(SafeFacilityFixture.CCTV5.getFacilityLatitude(), SafeFacilityFixture.CCTV5.getFacilityLongitude(), Type.CCTV);
        safeFacilityRepository.save(cctv5);
        //when
        List<Point> responsePoint = tmapApiService.getPoint( "36.421325","127.392238","36.422169", "127.388893");

        //then
        String expect = "[Point(latitude=36.42140535647647, longitude=127.39228489296808), Point(latitude=36.42174696899346, longitude=127.39144051480527), Point(latitude=36.420735963813776, longitude=127.39088503650011), Point(latitude=36.420552649750135, longitude=127.39078782797036), Point(latitude=36.42103867831523, longitude=127.38927683888134), Point(latitude=36.420994241381415, longitude=127.38941293901931), Point(latitude=36.421185887971774, longitude=127.38951847990971), Point(latitude=36.421405294786055, longitude=127.38881575906258), Point(latitude=36.421930240629194, longitude=127.38915182579835)]";
        assertEquals(expect,responsePoint.toString());

    }
}