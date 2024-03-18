package com.bada.badaback.kafka.service;

import com.bada.badaback.kafka.dto.AlarmDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class KafkaProducer {
  private static final String TOPIC = "alarm-topic";   // 전달되는 토픽의 이름

  @Autowired
  private final KafkaTemplate<String, AlarmDto> kafkaTemplate;
//  private final KafkaTemplate<String, String> kafkaTemplate;

//  public void sendMessage(String message) {
//    log.info("Produce message : {}", message);
//    this.kafkaTemplate.send(TOPIC, message);
//  }

  public void sendAlarm(String type, String userId, String content) {
    AlarmDto alarmDto = AlarmDto.builder()
        .type(type)
        .userId(userId)
        .content(content)
        .build();

    log.info("################## 리뷰 답글 알림 전송. type : {}, userId : {}, message : {}", type, userId, content);
    kafkaTemplate.send("alarm-topic", alarmDto);
  }

}