package com.ucan.repository;

import com.ucan.dto.CheckoutRequest;
import com.ucan.dto.FakeCardRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.security.MessageDigest;
import java.util.HexFormat;
import java.util.Map;

@Repository
public class CheckoutRepository {
  private final JdbcTemplate jdbc;

  public CheckoutRepository(JdbcTemplate jdbc) {
    this.jdbc = jdbc;
  }

  public BigDecimal findBalance(String userId) {
    return jdbc.queryForObject("select balance from user_balances where user_id = ?", BigDecimal.class, userId);
  }

  public long saveCard(String userId, FakeCardRequest card) {
    String last4 = card.cardNumber().substring(card.cardNumber().length() - 4);
    String masked = "**** **** **** " + last4;
    String cvvHash = sha(card.cvv());
    return jdbc.queryForObject(
      "insert into fake_cards(user_id, printed_name, card_number_masked, card_number_last4, expiration, cvv_hash, nickname, brand) values (?,?,?,?,?,?,?,?) returning id",
      Long.class, userId, card.printedName(), masked, last4, card.expiration(), cvvHash, card.nickname(), card.brand()
    );
  }

  public long createOrder(String userId, CheckoutRequest request, long cardId) {
    return jdbc.queryForObject(
      "insert into orders(user_id, total_amount, status, payment_method, fake_card_id, delivery_eta) values (?, ?, 'paid', ?, ?, '7-30 dias') returning id",
      Long.class, userId, request.total(), request.paymentMethod(), cardId
    );
  }

  public void saveOrderAddress(long orderId, Map<String, Object> address) {
    jdbc.update("insert into order_addresses(order_id, recipient_name, street, number, city, state, postal_code, country) values (?,?,?,?,?,?,?,?)",
      orderId,
      address.get("recipientName"), address.get("street"), address.get("number"), address.get("city"), address.get("state"),
      address.get("postalCode"), "Brazil");
  }

  public void saveItems(long orderId, CheckoutRequest request) {
    for (Map<String, Object> i : request.items()) {
      int qty = ((Number) i.get("qty")).intValue();
      BigDecimal price = new BigDecimal(String.valueOf(i.get("price")));
      jdbc.update("insert into order_items(order_id, product_id, product_name_snapshot, unit_price, quantity, subtotal) values (?,?,?,?,?,?)",
        orderId,
        ((Number) i.get("id")).longValue(),
        i.get("name"),
        price,
        qty,
        price.multiply(BigDecimal.valueOf(qty))
      );
    }
  }

  public void debitBalance(String userId, BigDecimal total) {
    jdbc.update("update user_balances set balance = balance - ?, updated_at = now() where user_id = ?", total, userId);
  }

  private String sha(String value) {
    try {
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      return HexFormat.of().formatHex(digest.digest(value.getBytes()));
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }
}
