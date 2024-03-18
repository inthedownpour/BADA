package com.bada.badaback.kafka.service;

import com.bada.badaback.kafka.dto.AlarmDto;
import java.io.IOException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class KafkaConsumer {

  @KafkaListener(topics = "alarm-topic", groupId = "foo")
  public void consume(AlarmDto alarmDto) throws IOException {
    log.info("################## Consumed AlarmDto : {}", alarmDto.toString());
  }


}
