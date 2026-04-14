import React from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';

export default function Header() {
  const { session, logout } = useAuth();
  const { items } = useCart();

  return (
    <header className="topbar">
      <Link to="/" className="brand">UCAN</Link>
      <nav>
        <Link to="/catalog">Catalog</Link>
        <Link to="/checkout">Checkout ({items.length})</Link>
        {session ? <Link to="/dashboard">Dashboard</Link> : <Link to="/login">Login</Link>}
      </nav>
      {session && <button onClick={logout} className="ghost">Logout</button>}
    </header>
  );
}
