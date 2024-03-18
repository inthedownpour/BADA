package com.bada.badaback.member.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.member.dto.MemberListResponseDto;
import com.bada.badaback.member.dto.MemberResponseDto;
import com.bada.badaback.member.service.MemberListService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "MemberList", description = "MemberListApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/members")
public class MemberListApiController {
    private final MemberListService memberListService;

    @GetMapping
    public ResponseEntity<MemberListResponseDto> familyList(@ExtractPayload Long memberId) {
        return ResponseEntity.ok(memberListService.familyList(memberId));
    }
}
