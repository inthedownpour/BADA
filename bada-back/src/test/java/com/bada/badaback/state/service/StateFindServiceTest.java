package com.bada.badaback.state.service;

import com.bada.badaback.common.ServiceTest;
import com.bada.badaback.global.exception.BaseException;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.state.domain.State;
import com.bada.badaback.state.exception.StateErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static com.bada.badaback.feature.MemberFixture.JIYEON;
import static com.bada.badaback.feature.MemberFixture.YONGJUN;
import static com.bada.badaback.feature.StateFixture.STATE1;
import static org.assertj.core.api.AssertionsForClassTypes.assertThat;
import static org.assertj.core.api.AssertionsForClassTypes.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.*;

class StateFindServiceTest extends ServiceTest {
    @Autowired
    private StateFindService stateFindService;
    @Autowired
    private MemberFindService memberFindService;

    private static Member parent;
    private static Member child;
    private static State state;


    @BeforeEach
    void setUp(){
        child = memberRepository.save(YONGJUN.toMember());
        parent = memberRepository.save(JIYEON.toMember());
        state = stateRepository.save(STATE1.toState(child));
    }

    @Test
    @DisplayName("Member로 멤버의 상태를 조회한다.")
    void findByMember() {
        //when
        State findState = stateFindService.findByMember(child);
        Member p = memberFindService.findByEmailAndSocial(parent.getEmail(), parent.getSocial());
        Member c = memberFindService.findByEmailAndSocial(child.getEmail(), child.getSocial());
        //then
        assertThatThrownBy(()->stateFindService.findByMember(p))
                .isInstanceOf(BaseException.class)
                .hasMessage(StateErrorCode.STATE_NOT_FOUND.getMessage());

        assertThat(findState).isEqualTo(state);
    }
}