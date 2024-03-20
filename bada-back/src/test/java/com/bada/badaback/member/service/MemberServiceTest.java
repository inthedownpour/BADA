package com.bada.badaback.member.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.dto.MemberDetailResponseDto;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Member [Service Layer] -> MemberService 테스트")
public class MemberServiceTest extends ServiceTest {
    @Autowired
    private MemberFindService memberFindService;

    @Autowired
    private MemberService memberService;

    private Member member;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
    }

    @Nested
    @DisplayName("회원 상세 조회")
    class read {
        @Test
        @DisplayName("회원 상세 조회에 성공한다")
        void success() {
            // when
            MemberDetailResponseDto memberDetailResponseDto = memberService.read(member.getId());

            // then
            assertAll(
                    () -> assertThat(memberDetailResponseDto.memberId()).isEqualTo(member.getId()),
                    () -> assertThat(memberDetailResponseDto.name()).isEqualTo(member.getName()),
                    () -> assertThat(memberDetailResponseDto.phone()).isEqualTo(member.getPhone()),
                    () -> assertThat(memberDetailResponseDto.email()).isEqualTo(member.getEmail()),
                    () -> assertThat(memberDetailResponseDto.social()).isEqualTo(member.getSocial().getSocialType()),
                    () -> assertThat(memberDetailResponseDto.profileUrl()).isEqualTo(member.getProfileUrl()),
                    () -> assertThat(memberDetailResponseDto.createdAt()).isEqualTo(member.getCreatedAt())
            );
        }
    }


    @Nested
    @DisplayName("회원 정보 수정")
    class update {
        @Test
        @DisplayName("회원 정보 수정에 성공한다")
        void success() {
            // given
            memberService.update(member.getId(), "새로운이름", null);

            // when
            Member findmember = memberFindService.findById(member.getId());

            // then
            assertAll(
                    () -> assertThat(findmember.getName()).isEqualTo("새로운이름"),
                    () -> assertThat(findmember.getProfileUrl()).isEqualTo(null)
            );
        }
    }

}
