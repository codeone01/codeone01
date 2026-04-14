package com.ucan.service;

import com.ucan.dto.CheckoutRequest;
import com.ucan.repository.CheckoutRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Map;

@Service
public class CheckoutService {
  private final CheckoutRepository repository;
  private final EmailService emailService;

  public CheckoutService(CheckoutRepository repository, EmailService emailService) {
    this.repository = repository;
    this.emailService = emailService;
  }

  @Transactional
  public Map<String, Object> place(String userId, String email, CheckoutRequest request) {
    validateCard(request);
    BigDecimal balance = repository.findBalance(userId);
    if (balance.compareTo(request.total()) < 0) {
      throw new IllegalArgumentException("Insufficient fictional balance");
    }

    long cardId = repository.saveCard(userId, request.fakeCard());
    long orderId = repository.createOrder(userId, request, cardId);
    repository.saveOrderAddress(orderId, request.shippingAddress());
    repository.saveItems(orderId, request);
    repository.debitBalance(userId, request.total());
    emailService.sendOrderConfirmation(email, orderId);
    return Map.of("orderId", orderId, "status", "paid");
  }

  private void validateCard(CheckoutRequest request) {
    String card = request.fakeCard().cardNumber();
    String exp = request.fakeCard().expiration();
    String cvv = request.fakeCard().cvv();
    if (!card.matches("\\d{13,19}")) throw new IllegalArgumentException("Invalid card number");
    if (!exp.matches("(0[1-9]|1[0-2])/[0-9]{2}")) throw new IllegalArgumentException("Invalid expiration");
    if (!cvv.matches("\\d{3,4}")) throw new IllegalArgumentException("Invalid cvv");
  }
}
