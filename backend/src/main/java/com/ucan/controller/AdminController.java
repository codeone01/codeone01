package com.ucan.controller;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminController {
  private final JdbcTemplate jdbc;

  public AdminController(JdbcTemplate jdbc) {
    this.jdbc = jdbc;
  }

  @GetMapping("/metrics")
  public Map<String, Object> metrics(Authentication authentication) {
    String userId = (String) authentication.getPrincipal();
    Boolean isAdmin = jdbc.queryForObject("select exists(select 1 from user_roles where user_id = ? and role = 'admin')", Boolean.class, userId);
    if (!Boolean.TRUE.equals(isAdmin)) {
      throw new IllegalArgumentException("Forbidden");
    }
    Long users = jdbc.queryForObject("select count(*) from profiles", Long.class);
    Long orders = jdbc.queryForObject("select count(*) from orders", Long.class);
    return Map.of("users", users, "orders", orders);
  }
}
