package com.bada.badaback.myplace.dto;

public record MyPlaceRequestDto(
        String placeName,
        String placeLatitude,
        String placeLongitude,
        String placeCategoryCode,
        String placePhoneNumber,
        String icon
) {
}
