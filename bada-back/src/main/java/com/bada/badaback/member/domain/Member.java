package com.bada.badaback.member.domain;

import com.bada.badaback.global.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor
@Table(name="members")
public class Member extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long id;

    @Column(nullable = false)
    private String name;

    private String phone;

    private String email;

    @Convert(converter = SocialType.SocialTypeConverter.class)
    @Column(length = 20)
    private SocialType social;

    @Column(nullable = false)
    private int isParent; // 부모라면 1, 아니면 0

    @Convert(converter = Role.RoleConverter.class)
    private Role role;

    @Column(length = 500)
    private String profileUrl;

    @Column(length = 20, nullable = false)
    private String familyCode;

    @Builder
    private Member(String name, String phone, String email, SocialType social, int isParent,
                   String profileUrl, String familyCode){
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.social = social;
        this.isParent = isParent;
        this.role = Role.USER;
        this.profileUrl = profileUrl;
        this.familyCode = familyCode;
    }

    public static Member createMember(String name, String phone, String email, SocialType social, int isParent,
                                      String profileUrl, String familyCode) {
        return new Member(name, phone, email, social, isParent, profileUrl, familyCode);
    }

    public void updateChildEmail(String ChildEmail) {
        this.email = ChildEmail;
    }

    public String getRoleKey() {
        return this.role.getAuthority();
    }

}