package com.bada.badaback.feature;

import com.bada.badaback.myplace.domain.MyPlace;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum MyPlaceFixture {
    MYPLACE_0("집", "35.111111", "127.111111", "SC4", "042-1111-1111", "icon0", "지번 주소", "도로명 주소"),
    MYPLACE_1("학교", "35.222222", "127.222222", "SC4", "042-2222-2222", "icon1", "지번 주소", "도로명 주소")
    ;

    private final String placeName;
    private final String placeLatitude;
    private final String placeLongitude;
    private final String placeCategoryCode;
    private final String placePhoneNumber;
    private final String icon;
    private final String addressName;
    private final String addressRoadName;

    public MyPlace toMyPlace(String familyCode) {
        return MyPlace.createMyPlace(placeName, placeLatitude, placeLongitude, placeCategoryCode,
                placePhoneNumber, icon, familyCode, addressName, addressRoadName);
    }
}
