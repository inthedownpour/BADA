package com.bada.badaback.route.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.feature.SafeFacilityFixture;
import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.domain.SafeFacility;
import com.bada.badaback.safefacility.domain.Type;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
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
        String expect = "[Point(latitude=36.42140535647647, longitude=127.39228489296808), Point(latitude=36.42140535647647, longitude=127.39228489296808), Point(latitude=36.42174696899346, longitude=127.39144051480527), Point(latitude=36.42174696899346, longitude=127.39144051480527), Point(latitude=36.42174696899346, longitude=127.39144051480527), Point(latitude=36.420735963813776, longitude=127.39088503650011), Point(latitude=36.420735963813776, longitude=127.39088503650011), Point(latitude=36.420735963813776, longitude=127.39088503650011), Point(latitude=36.420788732583055, longitude=127.39071838331442), Point(latitude=36.42086649888405, longitude=127.39057394968144), Point(latitude=36.42099147755337, longitude=127.39017953713967), Point(latitude=36.4210498008468, longitude=127.38999066356973), Point(latitude=36.42115811584508, longitude=127.38965735712316), Point(latitude=36.421174779516214, longitude=127.38959625102827), Point(latitude=36.421185887971774, longitude=127.38951847990971), Point(latitude=36.42119421931345, longitude=127.38946015157079), Point(latitude=36.42139418558964, longitude=127.38885186724391), Point(latitude=36.421405294786055, longitude=127.38881575906258), Point(latitude=36.421405294786055, longitude=127.38881575906258), Point(latitude=36.421405294786055, longitude=127.38881575906258), Point(latitude=36.421930240629194, longitude=127.38915182579835), Point(latitude=36.421930240629194, longitude=127.38915182579835)]";
        assertEquals(expect,responsePoint.toString());

    }
}