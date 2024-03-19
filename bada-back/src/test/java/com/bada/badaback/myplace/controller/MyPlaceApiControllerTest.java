package com.bada.badaback.myplace.controller;

import com.bada.badaback.auth.exception.AuthErrorCode;
import com.bada.badaback.common.ControllerTest;
import com.bada.badaback.myplace.dto.MyPlaceRequestDto;
import com.bada.badaback.myplace.dto.MyPlaceUpdateRequestDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static com.bada.badaback.feature.TokenFixture.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@DisplayName("MyPlace [Controller Layer] -> MyPlaceApiController 테스트")
public class MyPlaceApiControllerTest extends ControllerTest {

    @Nested
    @DisplayName("마이 플레이스 등록 API 테스트 [POST /api/myplace]")
    class createMyPlace {
        private static final String BASE_URL = "/api/myplace";

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            // when
            final MyPlaceRequestDto requestDto = createMyPlaceRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(APPLICATION_JSON);

            // then
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
        @DisplayName("마이 플레이스 등록에 성공한다")
        void success() throws Exception {
            // given
            doReturn(1L)
                    .when(myPlaceService)
                    .create(anyLong(), any(), any(), any(), any(), any(), any());

            // when
            final MyPlaceRequestDto requestDto = createMyPlaceRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .post(BASE_URL)
                    .content(convertObjectToJson(requestDto))
                    .contentType(APPLICATION_JSON)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("마이 플레이스 정보 수정 API 테스트 [PATCH /api/myplace]")
    class updateMyPlace {
        private static final String BASE_URL = "/api/myplace";
        private static final Long MYPLACE_ID = 1L;

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            // when
            final MyPlaceUpdateRequestDto requestDto = createMyPlaceUpdateRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .patch(BASE_URL, MYPLACE_ID)
                    .content(convertObjectToJson(requestDto))
                    .contentType(APPLICATION_JSON);

            // then
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
        @DisplayName("회원 정보 수정에 성공한다")
        void success() throws Exception {
            // given
            doNothing()
                    .when(memberService)
                    .update(anyLong(), any(), any());

            // when
            final MyPlaceUpdateRequestDto requestDto = createMyPlaceUpdateRequestDto();
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .patch(BASE_URL, MYPLACE_ID)
                    .content(convertObjectToJson(requestDto))
                    .contentType(APPLICATION_JSON)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    @Nested
    @DisplayName("마이 플레이스 삭제 API 테스트 [DELETE /api/myplace/{myPlaceId}]")
    class deleteMyPlace {
        private static final String BASE_URL = "/api/myplace/{myPlaceId}";
        private static final Long MYPLACE_ID = 1L;

        @Test
        @DisplayName("Authorization_Header에 RefreshToken이 없으면 예외가 발생한다")
        void throwExceptionByInvalidPermission() throws Exception {
            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .delete(BASE_URL, MYPLACE_ID);

            // then
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
        @DisplayName("마이 플레이스 삭제에 성공한다")
        void success() throws Exception {
            // given
            doNothing()
                    .when(myPlaceService)
                    .delete(anyLong(), anyLong());

            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .delete(BASE_URL, MYPLACE_ID)
                    .header(AUTHORIZATION, BEARER_TOKEN + ACCESS_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpectAll(
                            status().isOk()
                    );
        }
    }

    private MyPlaceRequestDto createMyPlaceRequestDto() {
        return new MyPlaceRequestDto("집", "35.111111", "127.111111", "SC4", "042-1111-1111", "icon0");
    }

    private MyPlaceUpdateRequestDto createMyPlaceUpdateRequestDto() {
        return new MyPlaceUpdateRequestDto("새로운 이름", "icon1");
    }
}
