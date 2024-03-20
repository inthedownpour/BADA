package com.bada.badaback.myplace.dto;

import jakarta.validation.constraints.NotBlank;

public record MyPlaceRequestDto(
        @NotBlank(message = "이름은 필수입니다.")
        String placeName,
        @NotBlank(message = "위도는 필수입니다.")
        String placeLatitude,
        @NotBlank(message = "경도는 필수입니다.")
        String placeLongitude,
        String placeCategoryCode,
        String placePhoneNumber,
        @NotBlank(message = "아이콘번호는 필수입니다.")
        String icon,
        @NotBlank(message = "지번 주소는 필수입니다.")
        String addressName,
        @NotBlank(message = "도로명 주소는 필수입니다.")
        String addressRoadName
) {
}
