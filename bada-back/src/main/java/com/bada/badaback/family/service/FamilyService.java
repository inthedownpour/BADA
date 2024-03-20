package com.bada.badaback.family.service;

import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.domain.FamilyRepository;
import com.bada.badaback.member.domain.Member;
import com.bada.badaback.member.service.MemberFindService;
import com.bada.badaback.myplace.service.MyPlaceService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Random;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FamilyService {
    private final FamilyRepository familyRepository;
    private final FamilyFindService familyFindService;
    private final MyPlaceService myPlaceService;
    private final MemberFindService memberFindService;

    @Transactional
    public String create(String familyName) {
        String familyCode = createRandomCode();

        while(familyRepository.existsByFamilyCode(familyCode)){
            familyCode = createRandomCode();
        }

        Family family = Family.createFamily(familyCode, familyName);
        return familyRepository.save(family).getFamilyCode();
    }

    @Transactional
    public void update(String familyCode, List<Long> placeList) {
        Family findFamily = familyFindService.findByFamilyCode(familyCode);
        findFamily.updatePlaceList(placeList);
    }

    @Transactional
    public void delete(Long memberId, String familyCode) {
        Member findMember= memberFindService.findById(memberId);
        Family findFamily = familyFindService.findByFamilyCode(familyCode);
        List<Long> placeList = findFamily.getPlaceList();

        if(placeList != null) {
            for(Long placeId : placeList){
                myPlaceService.delete(findMember.getId(), placeId);
            }
        }

        familyRepository.delete(findFamily);
    }

    private String createRandomCode() {
        int certCharLength = 5;
        final char[] characterTable = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
                'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0' };

        Random random = new Random(System.currentTimeMillis());
        int tablelength = characterTable.length;
        StringBuffer buf = new StringBuffer();

        for(int i = 0; i < certCharLength; i++) {
            buf.append(characterTable[random.nextInt(tablelength)]);
        }
        return buf.toString();
    }
}
