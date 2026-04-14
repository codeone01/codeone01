package com.ucan.dto;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public record CheckoutRequest(
    List<Map<String, Object>> items,
    BigDecimal total,
    Map<String, Object> shippingAddress,
    FakeCardRequest fakeCard,
    String paymentMethod
) {}
