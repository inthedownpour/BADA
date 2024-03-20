package com.bada.badaback.alarm.service;

import com.bada.badaback.alarm.domain.AlarmLog;
import com.bada.badaback.alarm.domain.AlarmRepository;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.exception.MemberErrorCode;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AlarmLogService {

  private final AlarmRepository alarmRepository;
  private final MemberRepository memberRepository;

  public List<AlarmLog> findById(Long memberId) {

    Optional<Member> member = memberRepository.findById(memberId);
    if (member.isEmpty()) {
      //      .orElseThrow( () -> BaseException.type(MemberErrorCode.MEMBER_NOT_FOUND) );
      // 찾는 회원 없다면 에러발생
    }

    return alarmRepository.findAllbyMemberId(memberId);
  }


  public String write() {

    return "success";
  }

}
