package com.bada.badaback.auth.controller;

import com.bada.badaback.auth.dto.AuthJoinRequestDto;
import com.bada.badaback.auth.dto.AuthSignUpRequestDto;
import com.bada.badaback.auth.service.AuthService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Auth", description = "AuthController API")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthApiController {
    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<Long> signup(@RequestBody AuthSignUpRequestDto requestDto) {
        System.out.println(requestDto);
        Long memberId = authService.signup(requestDto.name(), requestDto.phone(), requestDto.email(),
                requestDto.social(), requestDto.isParent(), requestDto.profileUrl(), requestDto.familyName());
        return new ResponseEntity<>(memberId, HttpStatus.OK);
    }

    @PostMapping("/join")
    public ResponseEntity<Long> join(@RequestBody AuthJoinRequestDto requestDto) {
        Long memberId = authService.join(requestDto.name(), requestDto.phone(), requestDto.email(),
                requestDto.social(), requestDto.isParent(), requestDto.profileUrl(), requestDto.authCode());
        return new ResponseEntity<>(memberId, HttpStatus.OK);
    }

}

