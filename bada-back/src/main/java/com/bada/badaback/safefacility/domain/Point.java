package com.bada.badaback.safefacility.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
public class Point {
    private Double longitude;
    private Double latitude;

    public Point(Double latitude, Double longitude){
        this.longitude = longitude;
        this.latitude = latitude;
    }
}
