package com.bada.badaback.state.domain;

import com.bada.badaback.member.domain.Member;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@Table(name = "state")
public class State {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String startLatitude;
    private String startLongitude;

    private String endLatitude;

    private String endLongitude;

    private String nowLatitude;

    private String nowLongitude;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id",referencedColumnName = "member_id")
    private Member member;

    private State(String startLatitude, String startLongitude, String endLatitude, String endLongitude, String nowLatitude, String nowLongitude, Member member) {
        this.startLatitude = startLatitude;
        this.startLongitude = startLongitude;
        this.endLatitude = endLatitude;
        this.endLongitude = endLongitude;
        this.nowLatitude = nowLatitude;
        this.nowLongitude = nowLongitude;
        this.member = member;
    }

    public static State createState(String startLatitude, String startLongitude, String endLatitude,
                                    String endLongitude, String nowLatitude, String nowLongitude, Member member){
        return new State(startLatitude,startLongitude,endLatitude, endLongitude,nowLatitude, nowLongitude, member);
    }

    public void updateState(String nowLatitude, String nowLongitude){
        this.nowLatitude = nowLatitude;
        this.nowLongitude = nowLongitude;
    }

}
