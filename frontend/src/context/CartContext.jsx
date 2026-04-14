import React, { createContext, useContext, useMemo, useState } from 'react';

const CartContext = createContext(null);

export function CartProvider({ children }) {
  const [items, setItems] = useState([]);

  function addToCart(product) {
    setItems((curr) => {
      const existing = curr.find((i) => i.id === product.id);
      if (existing) return curr.map((i) => (i.id === product.id ? { ...i, qty: i.qty + 1 } : i));
      return [...curr, { ...product, qty: 1 }];
    });
  }

  const clearCart = () => setItems([]);
  const total = useMemo(() => items.reduce((s, i) => s + i.price * i.qty, 0), [items]);

  return <CartContext.Provider value={{ items, addToCart, clearCart, total }}>{children}</CartContext.Provider>;
}

export const useCart = () => useContext(CartContext);
