package com.bada.badaback.member.controller;

import com.bada.badaback.common.ControllerTest;
import com.bada.badaback.member.dto.MemberListResponseDto;
import com.bada.badaback.member.dto.MemberResponseDto;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.util.ArrayList;
import java.util.List;

import static com.bada.badaback.feature.MemberFixture.*;
import static com.bada.badaback.feature.TokenFixture.BEARER_TOKEN;
import static com.bada.badaback.feature.TokenFixture.REFRESH_TOKEN;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.doReturn;
import static org.springframework.http.HttpHeaders.AUTHORIZATION;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@DisplayName("MemberList [Controller Layer] -> MemberListApiController 테스트")
public class MemberListApiControllerTest extends ControllerTest {

    @Nested
    @DisplayName("가족 목록 조회 API [GET /api/members]")
    class signup {
        private static final String BASE_URL = "/api/members";
        private static final String FamilyCode = "AB1111";

        @Test
        @DisplayName("가족 목록 조회에 성공한다")
        void success() throws Exception{
            // given
            doReturn(createBoardListResponses())
                    .when(memberListService)
                    .familyList(anyLong());

            // when
            MockHttpServletRequestBuilder requestBuilder = MockMvcRequestBuilders
                    .get(BASE_URL, FamilyCode)
                    .header(AUTHORIZATION, BEARER_TOKEN + REFRESH_TOKEN);

            // then
            mockMvc.perform(requestBuilder)
                    .andExpect(status().isOk());
        }
    }

    private MemberListResponseDto createBoardListResponses() {
        List<MemberResponseDto> memberList = new ArrayList<>();
        memberList.add(new MemberResponseDto(1L, SUNKYOUNG.getName(), SUNKYOUNG.getPhone(), SUNKYOUNG.getIsParent(), SUNKYOUNG.getProfileUrl(), 0));
        memberList.add(new MemberResponseDto(2L, JIYEON.getName(), JIYEON.getPhone(), JIYEON.getIsParent(), JIYEON.getProfileUrl(), 0));
        memberList.add(new MemberResponseDto(3L, YONGJUN.getName(), YONGJUN.getPhone(), YONGJUN.getIsParent(), YONGJUN.getProfileUrl(), 0));
        return new MemberListResponseDto(memberList);
    }
}
