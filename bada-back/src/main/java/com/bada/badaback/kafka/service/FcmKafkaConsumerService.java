package com.bada.badaback.kafka.service;

import com.bada.badaback.alarm.service.AlarmLogService;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.kafka.dto.AlarmDto;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.domain.MemberRepository;
import com.bada.badaback.member.exception.MemberErrorCode;
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

  private static boolean offCourse(String latitude, String longitude){
    return true;
  }

  @KafkaListener(topics = "${spring.kafka.topics.now-topic}", groupId = "foo")
  public void alarmListen(AlarmDto alarmDto) {

    // 좌표기준 알림 발생 매서드 사용으로 판단 로직 구현
    if ( offCourse(alarmDto.getLatitude(), alarmDto.getLongitude()) ) { //   현재 아이의 위치좌표가 범위를 벗어 난 경우
      // 알림을 보낼 패밀리의 맴버들을 가져오기
      List<Member> memberList = memberRepository.familyList(alarmDto.getFamilyCode());
      log.info("##################  memberList toString : {}", memberList.toString());

      if (memberList.isEmpty()) {
        log.info("##################  조회되는 패밀리 코드가 없습니다.");
        throw new BaseException(MemberErrorCode.MEMBER_NOT_FOUND);
      }

      // 보호자 핸드폰으로 알림 보내기




      // 알림 로그 기록
      alarmLogService.writeAlarmLog(alarmDto);

    } else {
      log.info("################## 아이는 정상범위 내에 있습니다. ");
    }

  }











}
