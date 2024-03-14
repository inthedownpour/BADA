package com.bada.badaback.auth.dto;


import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

public record AuthSignUpRequestDto(
        @NotBlank(message = "이름은 필수입니다.")
        String name,
        String phone,
        String email,
        String social,
        @Min(value = 0, message = "부모 여부는 0또는 1만 가능합니다.")
        @Max(value = 1, message = "부모 여부는 0또는 1만 가능합니다.")
        int isParent,
        String profileUrl,
        @NotBlank(message = "가족 코드는 필수입니다.")
        String familyName
) {
}
