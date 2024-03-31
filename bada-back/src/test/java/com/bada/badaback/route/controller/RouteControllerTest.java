package com.bada.badaback.route.controller;

import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ControllerTest;
import com.bada.badaback.route.dto.RouteRequestDto;
import com.bada.badaback.route.dto.RouteResponseDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.util.ArrayList;

import static com.bada.badaback.feature.TokenFixture.ACCESS_TOKEN;
import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class RouteControllerTest extends ControllerTest {

    @Nested
    @DisplayName("경로 등록 API 테스트 [POST /api/route]")
    class createRouteTest {
        private static final String BASE_URL = "/api/route";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            //when
            final RouteRequestDto requestDto = createRouteRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        @DisplayName("경로 정보 등록에 성공한다.")
        void createRoute() throws Exception {
            //given
            doNothing()
                    .when(routeService)
                    .createRoute(anyLong(),any());
            doNothing()
                    .when(memberService)
                    .updateMovingState(anyLong(), anyInt());

            //when
            final RouteRequestDto requestDto = createRouteRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            //Then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            MockMvcResultMatchers.status().isOk()
                    );
        }
    }


    @Nested
    @DisplayName("경로 조회 API 테스트 [GET /api/route/{childId}]")
    class getRouteTest {
        private static final String BASE_URL = "/api/route/{childId}";
        private static final Long CHILD_ID = 1L;

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL, CHILD_ID);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        @DisplayName("경로 정보 조회에 성공한다.")
        void getRoute() throws Exception {
            //given
            doReturn(createRouteResponseDto())
                    .when(routeService)
                    .getRoute(anyLong(), anyLong());

            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL, CHILD_ID)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            //Then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("경로 삭제 API 테스트 [DELETE /api/route]")
    class deleteRouteTest {
        private static final String BASE_URL = "/api/route";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .delete(BASE_URL);

            //then
            final AuthErrorCode expectedError = AuthErrorCode.INVALID_PERMISSION;
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isForbidden(),
                            jsonPath("$.status").exists(),
                            jsonPath("$.status").value(expectedError.getStatus().value()),
                            jsonPath("$.errorCode").exists(),
                            jsonPath("$.errorCode").value(expectedError.getErrorCode()),
                            jsonPath("$.message").exists(),
                            jsonPath("$.message").value(expectedError.getMessage())
                    );

        }

        @Test
        @DisplayName("경로 정보 삭제에 성공한다.")
        void deleteRoute() throws Exception {
            //given
            doNothing()
                    .when(routeService)
                    .deleteRoute(any());
            doNothing()
                    .when(memberService)
                    .updateMovingState(anyLong(), anyInt());

            //when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .delete(BASE_URL)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            //Then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            status().isOk()
                    );
        }
    }

    private RouteRequestDto createRouteRequestDto() {
        return new RouteRequestDto("36.421518", "127.391538", "36.421914", "127.38412", "출발", "도착");
    }

    private RouteResponseDto createRouteResponseDto() {
        return new RouteResponseDto(36.421518, 127.391538, 36.421914, 127.38412, "출발", "도착", new ArrayList<>());
    }
}