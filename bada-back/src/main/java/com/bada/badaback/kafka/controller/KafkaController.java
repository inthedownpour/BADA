package com.bada.badaback.kafka.controller;

import com.ssafy.bada.badaback.kafka.dto.AlarmDto;
import com.ssafy.bada.badaback.kafka.service.KafkaProducer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/kafka")
@Slf4j
@RequiredArgsConstructor
public class KafkaController {

  private final KafkaProducer producer;

  @PostMapping("/alarm")  // alarm이용
  @ResponseBody
  public String sendAlarm(@RequestBody AlarmDto alarmDto) {
    log.info("################## AlarmDto : {}", alarmDto.toString());
    log.info("################## send alarm : {}, {}, {}", alarmDto.getType(), alarmDto.getUserId(), alarmDto.getContent());
    producer.sendAlarm(alarmDto.getType(), alarmDto.getUserId(), alarmDto.getContent());

    return "success";
  }
}
