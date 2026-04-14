package com.ucan.dto;

public record FakeCardRequest(
    String printedName,
    String cardNumber,
    String expiration,
    String cvv,
    String nickname,
    String brand
) {}
