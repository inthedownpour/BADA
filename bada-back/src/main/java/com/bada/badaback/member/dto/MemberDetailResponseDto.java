package com.bada.badaback.member.dto;

import com.bada.badaback.member.domain.Member;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record MemberDetailResponseDto(
        Long memberId,
        String name,
        String phone,
        String email,
        String social,
        String profileUrl,
        LocalDateTime createdAt

) {
    public static MemberDetailResponseDto from(Member findMember) {
        return MemberDetailResponseDto.builder()
                .memberId(findMember.getId())
                .name(findMember.getName())
                .phone(findMember.getPhone())
                .email(findMember.getEmail())
                .social(findMember.getSocial().getSocialType())
                .profileUrl(findMember.getProfileUrl())
                .createdAt(findMember.getCreatedAt())
                .build();
    }
}
