package com.ucan.service;

import com.ucan.repository.CatalogRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CatalogService {
  private final CatalogRepository repository;

  public CatalogService(CatalogRepository repository) {
    this.repository = repository;
  }

  public List<Map<String, Object>> featured() {
    return repository.listFeatured();
  }
}
