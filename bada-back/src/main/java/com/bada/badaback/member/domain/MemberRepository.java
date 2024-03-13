package com.bada.badaback.member.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findByEmailAndSocial(String email, SocialType social);

    boolean existsByEmailAndSocial(String email, SocialType social);

    Optional<Member> findByEmail(String email);
}
