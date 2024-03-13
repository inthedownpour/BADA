package com.bada.badaback.feature;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.SocialType;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum MemberFixture {
    SUNKYOUNG("윤선경", "010-1111-1111","abc@naver.com", SocialType.NAVER, 1,null, "AB1111"),
    JIYEON("심지연", "010-2222-2222","def@naver.com", SocialType.KAKAO, 1,null, "AB2222"),
    YONGJUN("이용준", "010-3333-3333","ghi@naver.com", SocialType.KAKAO, 0,null, "AB3333")
    ;

    private final String name;
    private final String phone;
    private final String email;
    private final SocialType social;
    private final int isParent;
    private final String profileUrl;
    private final String familyCode;


    public Member toMember() {
        return Member.createMember(name, phone, email, social, isParent, profileUrl, familyCode);
    }
}
