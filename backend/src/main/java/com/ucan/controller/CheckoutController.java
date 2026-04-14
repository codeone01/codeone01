package com.ucan.controller;

import com.ucan.dto.CheckoutRequest;
import com.ucan.service.CheckoutService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/checkout")
public class CheckoutController {
  private final CheckoutService checkoutService;

  public CheckoutController(CheckoutService checkoutService) {
    this.checkoutService = checkoutService;
  }

  @PostMapping("/orders")
  public ResponseEntity<Map<String, Object>> createOrder(Authentication authentication, @RequestBody CheckoutRequest request) {
    String userId = (String) authentication.getPrincipal();
    String syntheticEmail = userId + "@ucan.local";
    return ResponseEntity.ok(checkoutService.place(userId, syntheticEmail, request));
  }
}
