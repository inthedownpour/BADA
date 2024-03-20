package com.bada.badaback.member.service;

import com.bada.badaback.file.service.FileService;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.dto.MemberDetailResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {
    private final MemberFindService memberFindService;
    private final FileService fileService;

    @Transactional
    public MemberDetailResponseDto read(Long memberId) {
        Member findMember = memberFindService.findById(memberId);

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

    @Transactional
    public void update(Long memberId, String name, MultipartFile file) {
        Member findMember = memberFindService.findById(memberId);

        String profileUrl = null;
        if (file != null)
            profileUrl = fileService.uploadMemberFiles(file);

        if(findMember.getProfileUrl() != null)
            fileService.deleteFiles(findMember.getProfileUrl());

        findMember.updateMember(name, profileUrl);
    }

}
