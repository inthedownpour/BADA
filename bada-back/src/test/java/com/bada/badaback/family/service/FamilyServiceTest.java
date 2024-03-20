package com.bada.badaback.family.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Family [Service Layer] -> FamilyService 테스트")
public class FamilyServiceTest extends ServiceTest {
    @Autowired
    private FamilyService familyService;

    @Autowired
    private FamilyFindService familyFindService;

    private Member member;
    private Family family;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        family = familyRepository.save(FAMILY_0.toFamily(member.getFamilyCode()));
    }

    @Test
    @DisplayName("Family 생성에 성공한다")
    void create() {
        // when
        Family findFamily = familyRepository.findByFamilyCode(family.getFamilyCode()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findFamily.getFamilyCode()).isEqualTo(member.getFamilyCode()),
                () -> assertThat(findFamily.getFamilyName()).isEqualTo("우리 가족"),
                () -> assertThat(findFamily.getPlaceList()).isNull()
        );
    }

    @Test
    @DisplayName("Family 도착지 목록 수정에 성공한다")
    void updatePlaceList() {
        // when
        List<Long> placeList = new ArrayList<>();
        placeList.add(1L);
        placeList.add(2L);
        placeList.add(3L);
        familyService.update(family.getFamilyCode(), placeList);
        Family findFamily = familyRepository.findByFamilyCode(family.getFamilyCode()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findFamily.getFamilyCode()).isEqualTo(member.getFamilyCode()),
                () -> assertThat(findFamily.getFamilyName()).isEqualTo("우리 가족"),
                () -> assertThat(findFamily.getPlaceList()).size().isEqualTo(3),
                () -> assertThat(findFamily.getPlaceList().get(0)).isEqualTo("1")
        );
    }

    @Test
    @DisplayName("Family 삭제를 성공한다")
    void delete() {
        // when
        familyService.delete(member.getId(), family.getFamilyCode());

        // then
        assertThatThrownBy(() -> familyFindService.findByFamilyCode(family.getFamilyCode()))
                .isInstanceOf(BaseException.class)
                .hasMessage(FamilyErrorCode.FAMILY_NOT_FOUND.getMessage());
    }
}
