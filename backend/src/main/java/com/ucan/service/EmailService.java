package com.ucan.service;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
  private final JavaMailSender mailSender;

  public EmailService(JavaMailSender mailSender) {
    this.mailSender = mailSender;
  }

  public void sendOrderConfirmation(String to, Long orderId) {
    SimpleMailMessage message = new SimpleMailMessage();
    message.setTo(to);
    message.setSubject("Ucan Order Confirmation #" + orderId);
    message.setText("Your fictional luxury order was confirmed successfully. This is a test transaction with no real payment.");
    mailSender.send(message);
  }
}
