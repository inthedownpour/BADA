package com.bada.badaback.family.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.exception.FamilyErrorCode;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.myplace.domain.MyPlace;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.FamilyFixture.FAMILY_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static com.bada.badaback.feature.MyPlaceFixture.MYPLACE_0;
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
    private MyPlace myPlace;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        family = familyRepository.save(FAMILY_0.toFamily(member.getFamilyCode()));
        myPlace = myPlaceRepository.save(MYPLACE_0.toMyPlace(member.getFamilyCode()));
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
        familyService.update(member.getId(), myPlace.getId());
        familyService.update(member.getId(), myPlace.getId());
        Family findFamily = familyRepository.findByFamilyCode(family.getFamilyCode()).orElseThrow();

        // then
        assertAll(
                () -> assertThat(findFamily.getFamilyCode()).isEqualTo(member.getFamilyCode()),
                () -> assertThat(findFamily.getFamilyName()).isEqualTo("우리 가족"),
                () -> assertThat(findFamily.getPlaceList()).size().isEqualTo(1),
                () -> assertThat(findFamily.getPlaceList().get(0)).isEqualTo(1L)
        );
    }

    @Test
    @DisplayName("Family 삭제를 성공한다")
    void delete() {
        // when
        familyService.delete(member.getId());

        // then
        assertThatThrownBy(() -> familyFindService.findByFamilyCode(family.getFamilyCode()))
                .isInstanceOf(BaseException.class)
                .hasMessage(FamilyErrorCode.FAMILY_NOT_FOUND.getMessage());
    }
}
