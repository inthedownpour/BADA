package com.bada.badaback.auth.service;

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

    @Transactional
    public Long signup(String name, String phone, String email, String social, int is_Parent, String profileUrl,
                       String familyName){
        Long findMemberId = DuplicateMember(email, social);
        if(findMemberId != null)
            return findMemberId;

        // 패밀리 생성 메소드 구현 이후 패밀리코드를 넣도록 수정 예정
        // 임시로 familyName을 familyCode 자리에 넣었음

        Member member = Member.createMember(name, phone, email, SocialType.valueOf(social), is_Parent, profileUrl, familyName);
        return memberRepository.save(member).getId();
    }

    @Transactional
    public Long join(String name, String phone, String email, String social, int is_Parent, String profileUrl,
                       String authCode){
        Long findMemberId = DuplicateMember(email, social);
        if(findMemberId != null)
            return findMemberId;

        // 인증번호 유효성 검사 API 구현 후 authCode 기반으로 찾은 familyCode를 저장하도록 수정할 예정

        Member member = Member.createMember(name, phone, email, SocialType.valueOf(social), is_Parent, profileUrl, authCode);
        return memberRepository.save(member).getId();
    }

    private Long DuplicateMember(String email, String social) {
        if(memberRepository.existsByEmailAndSocial(email, SocialType.valueOf(social))){
            return memberFindService.findByEmailAndSocial(email, SocialType.valueOf(social)).getId();
        }
        return null;
    }
}
