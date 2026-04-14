import React from 'react';

export default function FiltersPanel({ filters, onChange }) {
  const update = (e) => onChange({ ...filters, [e.target.name]: e.target.value });
  return (
    <section className="filters">
      <input name="search" placeholder="Search product name" value={filters.search || ''} onChange={update} />
      <input name="category" placeholder="Category" value={filters.category || ''} onChange={update} />
      <input name="subcategory" placeholder="Subcategory" value={filters.subcategory || ''} onChange={update} />
      <input name="brand" placeholder="Brand" value={filters.brand || ''} onChange={update} />
      <input name="type" placeholder="Type" value={filters.type || ''} onChange={update} />
      <input name="color" placeholder="Color" value={filters.color || ''} onChange={update} />
      <select name="sort" value={filters.sort || 'price_asc'} onChange={update}>
        <option value="price_asc">Price ↑</option>
        <option value="price_desc">Price ↓</option>
        <option value="name_asc">Name A-Z</option>
      </select>
    </section>
  );
}
