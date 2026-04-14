import React, { useEffect, useState } from 'react';
import { getCatalog } from '../services/catalogService';
import ProductCard from '../components/ProductCard';
import FiltersPanel from '../components/FiltersPanel';

export default function CatalogPage() {
  const [filters, setFilters] = useState({ sort: 'price_asc' });
  const [products, setProducts] = useState([]);

  useEffect(() => {
    getCatalog(filters).then(setProducts).catch(() => setProducts([]));
  }, [filters]);

  return (
    <main className="page">
      <h2>Luxury Catalog</h2>
      <FiltersPanel filters={filters} onChange={setFilters} />
      <section className="grid">
        {products.map((product) => <ProductCard product={product} key={product.id} />)}
      </section>
    </main>
  );
}
