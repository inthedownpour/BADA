package com.bada.badaback.family.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Family [Service Layer] -> FamilyService 테스트")
public class FamilyServiceTest extends ServiceTest {
    @Autowired
    private FamilyService familyService;

    private Family family;

    @BeforeEach
    void setup() {
        family = familyRepository.save(FAMILY_0.toFamily());
    }

    @Test
    @DisplayName("Family를 생성한다")
    void create() {
        // given
        String familyCode = familyService.create("우리 가족");

        // when
        Family findFamily = familyRepository.findByFamilyCode(familyCode).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findFamily.getFamilyCode()).isNotNull(),
                () -> assertThat(findFamily.getFamilyName()).isEqualTo("우리 가족"),
                () -> assertThat(findFamily.getPlaceList()).isNull()
        );
    }
}
