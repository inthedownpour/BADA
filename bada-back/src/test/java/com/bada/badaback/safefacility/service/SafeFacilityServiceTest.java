package com.bada.badaback.safefacility.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.safefacility.dto.SafeFacilityResponseDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("SafeFacility [Service Layer] -> SafeFacilityService 테스트")
class SafeFacilityServiceTest extends ServiceTest {
    @Autowired
    private SafeFacilityService safeFacilityService;

    @Test
    @DisplayName("getCCTV에서 출발지 도착지의 헥사곤 주소 테스트")
    void getCCTVs() throws IOException {
        //when
        SafeFacilityResponseDto responseDto = safeFacilityService.getCCTVs("127.390075","36.421435","127.387519","36.423531");
        //then

    }
}