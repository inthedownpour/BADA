package com.bada.badaback.auth.controller;

import com.bada.badaback.auth.dto.*;
import com.bada.badaback.auth.service.AuthService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Auth", description = "AuthApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthApiController {
    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<LoginResponseDto> signup(@RequestBody @Valid AuthSignUpRequestDto requestDto) {
        Long memberId = authService.signup(requestDto.name(), requestDto.phone(), requestDto.email(),
                requestDto.social(), requestDto.profileUrl(), requestDto.familyName(), requestDto.fcmToken());
        LoginResponseDto responseDto = authService.login(memberId);
        return ResponseEntity.ok(responseDto);
    }

    @PostMapping("/join")
    public ResponseEntity<LoginResponseDto> join(@RequestBody @Valid AuthJoinRequestDto requestDto) {
        Long memberId = authService.join(requestDto.name(), requestDto.phone(), requestDto.email(),
                requestDto.social(), requestDto.profileUrl(), requestDto.code(), requestDto.fcmToken());
        LoginResponseDto responseDto = authService.login(memberId);
        return ResponseEntity.ok(responseDto);
    }

    @PostMapping("/joinChild")
    public ResponseEntity<LoginResponseDto> joinChild(@RequestBody @Valid AuthJoinChildRequestDto requestDto) {
        Long memberId = authService.joinChild(requestDto.name(), requestDto.phone(), requestDto.profileUrl(), requestDto.code(),
                requestDto.fcmToken());
        LoginResponseDto responseDto = authService.login(memberId);
        return ResponseEntity.ok(responseDto);
    }

    @GetMapping
    public ResponseEntity<LoginResponseDto> alreadyMember(@RequestBody @Valid AuthAlreadyRequestDto requestDto) {
        Long memberId = authService.AlreadyMember(requestDto.email(), requestDto.social());
        if(memberId == null){
            return ResponseEntity.noContent().build();
        }
        LoginResponseDto responseDto = authService.login(memberId);
        return ResponseEntity.ok(responseDto);
    }

}

