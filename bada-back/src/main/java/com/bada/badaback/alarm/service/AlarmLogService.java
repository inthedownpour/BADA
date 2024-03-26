package com.bada.badaback.alarm.service;

import com.bada.badaback.alarm.domain.AlarmLog;
import com.bada.badaback.alarm.domain.AlarmRepository;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.exception.MemberErrorCode;
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

  public List<AlarmLog> getAllAlarmLogs(Long memberId) {
    Optional<Member> member = memberRepository.findById(memberId);
    if (member.isEmpty()) { // 찾는 회원 없다면 에러발생
      throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }
    return alarmRepository.findAllAlarmLogsbyMemberId(memberId);
  }

  public String writeAlarmLog(AlarmDto alarmDto) {
    Optional<Member> optMember = memberRepository.findById(Long.valueOf(alarmDto.getMemberId()));
    if (optMember.isEmpty()) { // 찾는 회원 없다면 에러발생
       throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }
    AlarmLog alarmLog = AlarmLog.createAlarmLog(alarmDto.getType(), optMember.get());
    alarmRepository.save(alarmLog);
    return "AlarmLog write success";
  }


}
