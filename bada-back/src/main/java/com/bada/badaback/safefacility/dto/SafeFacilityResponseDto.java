package com.bada.badaback.safefacility.dto;

import com.bada.badaback.safefacility.domain.SafeFacility;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;

@Builder
public record SafeFacilityResponseDto(
        String startX,
        String startY,
        String endX,
        String endY,
        String reqCoordType,
        String resCoordType,
        String startName,
        String endName,
        String passList
) {
    public SafeFacilityResponseDto from(String startX,
                                        String startY,
                                        String endX,
                                        String endY,
                                        String startName,
                                        String endName,
                                        String passList){
        return SafeFacilityResponseDto.builder()
                .startX(startX)
                .startY(startY)
                .endX(endX)
                .endY(endY)
                .reqCoordType("WGS84GEO")
                .resCoordType("EPSG3857")
                .startName(startName)
                .endName(endName)
                .passList(passList)
                .build();
    }
}
