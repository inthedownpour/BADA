package com.bada.badaback.member.dto;

import lombok.Builder;

@Builder
public record MemberResponseDto(
        Long memberId,
        String name,
        String phone,
        int isParent,
        String profileUrl,
        int movingState
) {
}
