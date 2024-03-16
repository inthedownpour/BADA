package com.bada.badaback.auth.service;

import com.bada.badaback.auth.domain.AuthCode;
import com.bada.badaback.auth.domain.Token;
import com.bada.badaback.auth.dto.LoginResponseDto;
import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.security.JwtProvider;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.SocialType;
import com.bada.badaback.member.service.MemberFindService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.AuthCodeFixture.AUTHCODE_0;
import static com.bada.badaback.feature.MemberFixture.SUNKYOUNG;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertAll;

@DisplayName("Auth [Service Layer] -> AuthService 테스트")
public class AuthServiceTest extends ServiceTest {
    @Autowired
    private AuthService authService;

    @Autowired
    private AuthCodeFindService authCodeFindService;

    @Autowired
    private JwtProvider jwtProvider;

    @Autowired
    private MemberFindService memberFindService;

    private Member member;
    private AuthCode authCode;

    @BeforeEach
    void setup() {
        member = memberRepository.save(SUNKYOUNG.toMember());
        authCode = authCodeRepository.save(AUTHCODE_0.toAuthCode(member));

    }

    @Test
    @DisplayName("회원가입에 성공한다(새로운 가족 그룹 생성)")
    void signup() {
        // when
        Long saveMemberId = authService.signup("윤선경", "010-1111-1111","abc@naver.com", "NAVER", null, "우리 가족");

        // then
        Member findMember = memberFindService.findById(saveMemberId);
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo("윤선경"),
                () -> assertThat(findMember.getPhone()).isEqualTo("010-1111-1111"),
                () -> assertThat(findMember.getEmail()).isEqualTo("abc@naver.com"),
                () -> assertThat(findMember.getSocial()).isEqualTo(SocialType.NAVER),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(null),
                () -> assertThat(findMember.getFamilyCode()).isNotNull()
        );
    }

    @Test
    @DisplayName("회원가입에 성공한다(기존 가족 그룹 가입)")
    void join() {
        // when
        Long saveMemberId = authService.join("심지연", "010-2222-2222","def@naver.com", "KAKAO", null, authCode.getCode());

        // then
        Member findMember = memberFindService.findById(saveMemberId);
        String findFamilyCode = authCodeFindService.findMemberByCode(authCode.getCode()).getFamilyCode();
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo("심지연"),
                () -> assertThat(findMember.getPhone()).isEqualTo("010-2222-2222"),
                () -> assertThat(findMember.getEmail()).isEqualTo("def@naver.com"),
                () -> assertThat(findMember.getSocial()).isEqualTo(SocialType.KAKAO),
                () -> assertThat(findMember.getIsParent()).isEqualTo(1),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(null),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo(findFamilyCode)
        );
    }

    @Test
    @DisplayName("아이 회원가입에 성공한다(기존 가족 그룹 가입)")
    void joinChild() {
        // when
        Long saveMemberId = authService.joinChild("심지연", "010-2222-2222", null, authCode.getCode());

        // then
        Member findMember = memberFindService.findById(saveMemberId);
        String findFamilyCode = authCodeFindService.findMemberByCode(authCode.getCode()).getFamilyCode();
        assertAll(
                () -> assertThat(findMember.getName()).isEqualTo("심지연"),
                () -> assertThat(findMember.getPhone()).isEqualTo("010-2222-2222"),
                () -> assertThat(findMember.getEmail()).isNotNull(),
                () -> assertThat(findMember.getSocial()).isEqualTo(SocialType.CHILD),
                () -> assertThat(findMember.getIsParent()).isEqualTo(0),
                () -> assertThat(findMember.getProfileUrl()).isEqualTo(null),
                () -> assertThat(findMember.getFamilyCode()).isEqualTo(findFamilyCode)
        );
    }

    @Test
    @DisplayName("로그인에 성공한다")
    void login() {
        // when
        Long saveMemberId = authService.signup("윤선경", "010-1111-1111","abc@naver.com", "NAVER", null, "우리 가족");
        LoginResponseDto loginResponseDto = authService.login(saveMemberId);

        // then
        Member findMember = memberFindService.findById(saveMemberId);
        assertAll(
                () -> assertThat(jwtProvider.getId(loginResponseDto.accessToken())).isEqualTo(saveMemberId),
                () -> assertThat(jwtProvider.getId(loginResponseDto.refreshToken())).isEqualTo(saveMemberId),
                () -> assertThat(loginResponseDto.memberId()).isEqualTo(saveMemberId),
                () -> assertThat(loginResponseDto.name()).isEqualTo("윤선경"),
                () -> assertThat(loginResponseDto.familyCode()).isEqualTo(findMember.getFamilyCode()),
                () -> {
                    Token findToken = tokenRepository.findByMemberId(saveMemberId).orElseThrow();
                    assertThat(loginResponseDto.refreshToken()).isEqualTo(findToken.getRefreshToken());
                }
        );
    }
}
