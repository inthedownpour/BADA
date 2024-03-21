package com.bada.badaback.state.dto;

public record StateRequestDto(
        String startLat,
        String startLong,
        String endLat,
        String endLong,
        String nowLat,
        String nowLong
) {
}
