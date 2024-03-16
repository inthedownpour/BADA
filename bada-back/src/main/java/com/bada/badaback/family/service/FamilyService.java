package com.bada.badaback.family.service;

import com.bada.badaback.family.domain.Family;
import com.bada.badaback.family.domain.FamilyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Random;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class FamilyService {
    private final FamilyRepository familyRepository;
    private final FamilyFindService familyFindService;

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
    public void delete(String familyCode) {
        Family findfamily = familyFindService.findByFamilyCode(familyCode);
        familyRepository.delete(findfamily);
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
