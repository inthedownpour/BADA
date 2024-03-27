package com.bada.badaback.kafka.controller;


import com.bada.badaback.alarmlog.service.AlarmLogService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
public class AlarmConnectController {

//  private final EmitterService emitterService;
  private final AlarmLogService alarmLogService;

  public static final Long DEFAULT_TIMEOUT = 3600L * 1000;

//  @GetMapping(value = "/api/sse-connection", produces = "text/event-stream")
//  public SseEmitter stream(@Login SessionUser sessionUser, @RequestHeader(value = "Last-Event-ID", required = false, defaultValue = "") String lastEventId) throws IOException {
//    return emitterService.addEmitter(String.valueOf(sessionUser.getUserIdNo()), lastEventId);
//  }



}