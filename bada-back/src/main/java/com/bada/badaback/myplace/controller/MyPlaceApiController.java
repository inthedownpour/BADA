package com.bada.badaback.myplace.controller;

import com.bada.badaback.global.annotation.ExtractPayload;
import com.bada.badaback.myplace.dto.MyPlaceRequestDto;
import com.bada.badaback.myplace.dto.MyPlaceUpdateRequestDto;
import com.bada.badaback.myplace.service.MyPlaceService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Tag(name = "MyPlace", description = "MyPlaceApiController")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/myplace")
public class MyPlaceApiController {
    private final MyPlaceService myPlaceService;

    @PostMapping
    public ResponseEntity<Void> create(@ExtractPayload Long memberId, @RequestBody MyPlaceRequestDto requestDto) {
        myPlaceService.create(memberId, requestDto.placeName(), requestDto.placeLatitude(), requestDto.placeLongitude(), requestDto.placeCategoryCode(),
                requestDto.placePhoneNumber(), requestDto.icon(), requestDto.addressName(), requestDto.addressRoadName());
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{myPlaceId}")
    public ResponseEntity<Void> update (@ExtractPayload Long memberId, @PathVariable("myPlaceId") Long myPlaceId, @RequestBody MyPlaceUpdateRequestDto requestDto) {
        myPlaceService.update(memberId, myPlaceId, requestDto.placeName(), requestDto.icon());
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{myPlaceId}")
    public ResponseEntity<Void> delete (@ExtractPayload Long memberId, @PathVariable("myPlaceId") Long myPlaceId) {
        myPlaceService.delete(memberId, myPlaceId);
        return ResponseEntity.ok().build();
    }

}
