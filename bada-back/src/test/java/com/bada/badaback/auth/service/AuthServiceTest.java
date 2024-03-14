package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.Token;
import com.bada.badaback.auth.dto.LoginResponseDto;
import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.SocialType;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Auth [Service Layer] -> AuthService 테스트")
public class AuthServiceTest extends ServiceTest {
    @Autowired
    private AuthService authService;

    @Test
    @DisplayName("회원가입에 성공한다(새로운 가족 그룹 생성)")
    void signup() {
        // when
        Long saveMemberId = authService.signup("윤선경", "010-1111-1111","abc@naver.com", "NAVER", 1,null, "우리가족");

        // then
        Member findMember = memberRepository.findById(saveMemberId).orElseThrow();
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo("윤선경"),
                () -> assertThat(findMember.getPhone()).isEqualTo("010-1111-1111"),
                () -> assertThat(findMember.getEmail()).isEqualTo("abc@naver.com"),
                () -> assertThat(findMember.getSocial()).isEqualTo(SocialType.NAVER),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(null),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo("우리가족") // 가족코드 생성구현 이후 변경 예정
        );
    }

    @Test
    @DisplayName("회원가입에 성공한다(기존 가족 그룹 가입)")
    void join() {
        // when
        Long saveMemberId = authService.join("심지연", "010-2222-2222","def@naver.com", "KAKAO", 1,null, "AWESDF");

        // then
        Member findMember = memberRepository.findById(saveMemberId).orElseThrow();
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo("심지연"),
                () -> assertThat(findMember.getPhone()).isEqualTo("010-2222-2222"),
                () -> assertThat(findMember.getEmail()).isEqualTo("def@naver.com"),
                () -> assertThat(findMember.getSocial()).isEqualTo(SocialType.KAKAO),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(null),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo("AWESDF") // 인증코드 생성구현 이후 변경예정
        );
    }

    @Test
    @DisplayName("로그인에 성공한다")
    void login() {
        // when
        Long saveMemberId = authService.signup("윤선경", "010-1111-1111","abc@naver.com", "NAVER", 1,null, "AB1111");
        LoginResponseDto loginResponseDto = authService.login(saveMemberId);

        // then
        assertAll(
                () -> assertThat(loginResponseDto.memberId()).isEqualTo(saveMemberId),
                () -> assertThat(loginResponseDto.name()).isEqualTo("윤선경"),
                () -> {
                    Token findToken = tokenRepository.findByMemberId(saveMemberId).orElseThrow();
                    assertThat(loginResponseDto.refreshToken()).isEqualTo(findToken.getRefreshToken());
                }
        );
    }
}
