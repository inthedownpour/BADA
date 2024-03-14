package com.bada.badaback.auth.service;

import com.bada.badaback.auth.dto.LoginResponseDto;
import com.bada.badaback.global.security.JwtProvider;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.domain.SocialType;
import com.bada.badaback.member.service.MemberFindService;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthService {

    private final MemberRepository memberRepository;
    private final MemberFindService memberFindService;
    private final JwtProvider jwtProvider;
    private final TokenService tokenService;

    @Transactional
    public Long signup(String name, String phone, String email, String social, int isParent, String profileUrl,
                       String familyName){
        Long memberId = AlreadyMember(email, social);

        if(memberId == null) {
            // 패밀리 생성 메소드 구현 이후 패밀리코드를 넣도록 수정 예정
            // 임시로 familyName을 familyCode 자리에 넣었음
            Member member = Member.createMember(name, phone, email, SocialType.valueOf(social), isParent, profileUrl, familyName);
            memberId = memberRepository.save(member).getId();

            String accessToken = jwtProvider.createAccessToken(memberId, member.getRole());
            String refreshToken = jwtProvider.createRefreshToken(memberId, member.getRole());
            tokenService.synchronizeRefreshToken(member.getId(), refreshToken);
        }

        return memberId;
    }

    @Transactional
    public Long join(String name, String phone, String email, String social, int isParent, String profileUrl,
                       String code){
        Long memberId = AlreadyMember(email, social);
        if(memberId == null) {

            // 인증번호 유효성 검사 API 구현 후 authCode 기반으로 찾은 familyCode를 저장하도록 수정할 예정
            Member member = Member.createMember(name, phone, email, SocialType.valueOf(social), isParent, profileUrl, code);
            memberId = memberRepository.save(member).getId();
        }

        return memberId;
    }

    @Transactional
    public LoginResponseDto login(Long memberId) {
        Member member = memberFindService.findById(memberId);

        if(member.getIsParent() == 0){
            member.updateChildEmail(childEmail(memberId));
        }

        String accessToken = jwtProvider.createAccessToken(member.getId(), member.getRole());
        String refreshToken = jwtProvider.createRefreshToken(member.getId(), member.getRole());
        tokenService.synchronizeRefreshToken(member.getId(), refreshToken);

        return LoginResponseDto.builder()
                .memberId(member.getId())
                .name(member.getName())
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private Long AlreadyMember(String email, String social) {
        if(memberRepository.existsByEmailAndSocial(email, SocialType.valueOf(social))){
            return memberFindService.findByEmailAndSocial(email, SocialType.valueOf(social)).getId();
        }
        return null;
    }

    private String childEmail(Long memberId) {
        String number = String.valueOf((int)(Math.random() * 99) + 10);
        return "bada"+number+String.valueOf(memberId)+"@bada.com";
    }
}
