package com.bada.badaback.safefacility.service;

import com.bada.badaback.safefacility.domain.Point;
import com.bada.badaback.safefacility.domain.SafeFacilityRepository;
import com.bada.badaback.safefacility.dto.SafeFacilityResponseDto;
import com.uber.h3core.H3Core;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class SafeFacilityService {
    private final SafeFacilityRepository safeFacilityRepository;

    //CCTV 출발 시작 좌표로 가져오기
    //두 지점의 거리를 구하고 그것의 반만큼의 거리를 구한다.
    //
    public SafeFacilityResponseDto getCCTVs(String startX, String startY, String endX, String endY) throws IOException {
        Point start = new Point(Double.parseDouble(startY), Double.parseDouble(startX));
        Point end = new Point(Double.parseDouble(endY), Double.parseDouble(endX));

        SafeFacilityResponseDto path = null;

        //도착지와 출발지의 h3값 찾기
        H3Core h3 = H3Core.newInstance();
        int res = 13;
        String startHexAddr = h3.latLngToCellAddress(start.getLatitude(), start.getLongitude(), res);
        String endHexAddr = h3.latLngToCellAddress(end.getLatitude(), end.getLongitude(), res);

        System.out.println("출발지 헥사곤 주소: " + startHexAddr);
        System.out.println("도착지 헥사곤 주소: " + endHexAddr);

        return path;
    }
}
