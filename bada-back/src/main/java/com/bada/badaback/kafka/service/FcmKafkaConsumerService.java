package com.bada.badaback.kafka.service;

import com.bada.badaback.alarm.service.AlarmLogService;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.exception.MemberErrorCode;
import com.bada.badaback.member.service.MemberListService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class FcmKafkaConsumerService {

  private final AlarmLogService alarmLogService;
  private final MemberRepository memberRepository;

  @KafkaListener(topics = "${spring.kafka.topics.now-topic}", groupId = "foo")
  public void alarmListen(AlarmDto alarmDto) {
    log.info("################## Consumed AlarmDto : {}", alarmDto.toString());

    List<Member> memberList = memberRepository.familyList(alarmDto.getFamilyCode());
    log.info("##################  memberList toString : {}", memberList.toString());
    if (memberList.isEmpty()) {
      log.info("##################  조회되는 패밀리 코드가 없습니다.");
      throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
    }

    /**
     * 범위 이탈 로직 부분 후보 2.
     *  해당 부분에서 좌표를 기준으로 알림을 발생시켜야한다.
     **/



    // 좌표가 들어오면 좌표를 기준으로 계산을 진행한다.


  }


}
