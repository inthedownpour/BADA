package com.bada.badaback.myplace.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
@Table(name="myplace")
public class MyPlace {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "myplace_id")
    private Long id;

    @Column(nullable = false)
    private String placeName;

    @Column(nullable = false)
    private String placeLatitude;

    @Column(nullable = false)
    private String placeLongitude;

    @Column(length = 10)
    private String placeCategoryCode;

    private String placePhoneNumber;

    @Column(length = 30, nullable = false)
    private String icon;

    @Column(length = 20, nullable = false)
    private String familyCode;

    @Column(nullable = false)
    private String addressName;

    @Column(nullable = false)
    private String addressRoadName;

    private MyPlace(String placeName, String placeLatitude, String placeLongitude, String placeCategoryCode,
                    String placePhoneNumber, String icon, String familyCode, String addressName, String addressRoadName){
        this.placeName = placeName;
        this.placeLatitude = placeLatitude;
        this.placeLongitude = placeLongitude;
        this.placeCategoryCode = placeCategoryCode;
        this.placePhoneNumber = placePhoneNumber;
        this.icon = icon;
        this.familyCode = familyCode;
        this.addressName = addressName;
        this.addressRoadName = addressRoadName;
    }

    public static MyPlace createMyPlace(String placeName, String placeLatitude, String placeLongitude, String placeCategoryCode,
                                        String placePhoneNumber, String icon, String familyCode, String addressName, String addressRoadName) {
        return new MyPlace(placeName, placeLatitude, placeLongitude, placeCategoryCode, placePhoneNumber,
                icon, familyCode, addressName, addressRoadName);
    }

    public void updateMyPlace(String placeName, String icon) {
        this.placeName = placeName;
        this.icon = icon;
    };
}
