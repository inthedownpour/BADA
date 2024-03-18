package com.bada.badaback.member.service;

import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.dto.MemberResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberListService {
    private final MemberRepository memberRepository;
    private final MemberFindService memberFindService;

    @Transactional
    public List<MemberResponseDto> familyList(Long memberId) {
        Member findMember = memberFindService.findById(memberId);

        List<Member> memberList = memberRepository.familyList(findMember.getFamilyCode());
        List<MemberResponseDto> familyList = new ArrayList<>();

        for (Member member : memberList) {
            MemberResponseDto memberResponseDto = MemberResponseDto.builder()
                    .memberId(member.getId())
                    .name(member.getName())
                    .isParent(member.getIsParent())
                    .phone(member.getPhone())
                    .profileUrl(member.getProfileUrl())
                    .movingState(0) //state 구현 이후 수정 예정
                    .build();
            familyList.add(memberResponseDto);
        }
        return familyList;
    }
}
