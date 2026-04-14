package com.ucan.repository;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class CatalogRepository {
  private final JdbcTemplate jdbc;

  public CatalogRepository(JdbcTemplate jdbc) {
    this.jdbc = jdbc;
  }

  public List<Map<String, Object>> listFeatured() {
    return jdbc.queryForList("select * from v_catalog_products where featured = true order by price desc limit 16");
  }
}
