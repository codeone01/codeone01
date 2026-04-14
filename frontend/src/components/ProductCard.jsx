import React from 'react';
import { useCart } from '../context/CartContext';

export default function ProductCard({ product }) {
  const { addToCart } = useCart();
  return (
    <article className="card">
      <img src={product.primary_image || 'https://placehold.co/400x300'} alt={product.name} />
      <h3>{product.name}</h3>
      <p>{product.short_description}</p>
      <strong>R$ {Number(product.price).toLocaleString('pt-BR')}</strong>
      <button onClick={() => addToCart(product)}>Add to Cart</button>
    </article>
  );
}
