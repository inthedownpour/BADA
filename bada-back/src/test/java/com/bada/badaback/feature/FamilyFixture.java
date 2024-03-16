package com.bada.badaback.feature;

import com.bada.badaback.family.domain.Family;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum FamilyFixture {
    FAMILY_0("AB1111", "우리가족"),
    FAMILY_1("AB2222", "우리가족")
    ;

    private final String familyCode;
    private final String familyName;

    public Family toFamily() {
        return Family.createFamily(familyCode, familyName);
    }
}