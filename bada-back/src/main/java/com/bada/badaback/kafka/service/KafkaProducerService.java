package com.bada.badaback.kafka.service;

import com.bada.badaback.kafka.dto.AlarmDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class KafkaProducer {
  @Value(value = "${spring.kafka.topics.name}")
  private String topic;   // 전달되는 토픽의 이름

  @Autowired
  private final KafkaTemplate<String, AlarmDto> kafkaTemplate;

  public void sendAlarm(String type, String memberId, String content, String familyCode) {
    AlarmDto alarmDto = AlarmDto.builder()
        .type(type)
        .memberId(memberId)
        .familyCode(familyCode)
        .content(content)
        .build();

    log.info("################## 리뷰 답글 알림 전송. type : {}, memberId : {}, message : {}", type, memberId, content);
//    kafkaTemplate.send(alarmTopic, alarmDto);  // alarm : topic에 해당하는 이름 없으면 자동 생성됨
    kafkaTemplate.send(topic, alarmDto);  // test : topic에 해당하는 이름 없으면 자동 생성됨

  }

}