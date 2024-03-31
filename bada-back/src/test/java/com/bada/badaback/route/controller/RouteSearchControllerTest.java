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

import java.util.ArrayList;

import static com.bada.badaback.feature.TokenFixture.ACCESS_TOKEN;
import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class RouteSearchControllerTest extends ControllerTest {
    @Nested
    @DisplayName("경로 검색 API 테스트 [POST /api/path]")
    class searchRouteTest{
        private static final String BASE_URL ="/api/path";
        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception{
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
        @DisplayName("경로 정보 조회에 성공한다.")
        void searchRoute() throws Exception {
            //given
            doReturn(createRouteResponseDto())
                    .when(routeSearchService)
                    .searchRoute(anyLong(),any(),any(),any(),any(),any(),any());

            //when
            final RouteRequestDto requestDto = createRouteRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .header(AUTHORIZATION,BEARER_TOKEN+ACCESS_TOKEN)
                    .content(convertObjectToJson(requestDto))
                    .contentType(MediaType.APPLICATION_JSON);

            //Then
            mockMvc.perform(requestBuilder)
                    .andExpect(
                            status().isOk()
                    );
        }
    }

    private RouteRequestDto createRouteRequestDto(){
        return new RouteRequestDto("36.421518","127.391538","36.421914","127.38412","츌발지 이름", "도착지 이름");
    }

    private RouteResponseDto createRouteResponseDto(){
        return new RouteResponseDto(36.421518,127.391538,36.421914,127.38412,"출발지 이름","도착지 이름",new ArrayList<>());
    }

}