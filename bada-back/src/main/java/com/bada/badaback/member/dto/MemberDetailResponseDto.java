package com.bada.badaback.member.dto;

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
}
