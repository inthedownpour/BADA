package com.bada.badaback.kafka.exception;

import com.bada.badaback.global.exception.ErrorCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;

@Getter
@RequiredArgsConstructor
public enum AlarmErrorCode implements ErrorCode {

  CATCH_ALARM_OffCOURSE_TEST(HttpStatus.NOT_FOUND, "ALARM_001", "일부러 테스트하려고 아이 경로 이탈 알림을 발생시켰습니다."),
  ;

  private final HttpStatus status;
  private final String errorCode;
  private final String message;
}
