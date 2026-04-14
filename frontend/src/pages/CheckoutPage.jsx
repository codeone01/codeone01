import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';
import { placeOrder } from '../services/checkoutService';

export default function CheckoutPage() {
  const { session } = useAuth();
  const { items, total, clearCart } = useCart();
  const [form, setForm] = useState({
    recipientName: '', street: '', number: '', city: '', state: '', postalCode: '',
    printedName: '', cardNumber: '', expiration: '', cvv: '', nickname: '', brand: 'Visa'
  });
  const [message, setMessage] = useState('');

  const onChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  async function submit(e) {
    e.preventDefault();
    if (!session?.access_token) return setMessage('Please login first');
    await placeOrder(session.access_token, { items, total, shippingAddress: form, fakeCard: form, paymentMethod: 'card' });
    clearCart();
    setMessage('Order placed. Confirmation email sent.');
  }

  return (
    <main className="page form-wrap">
      <h2>Checkout</h2>
      <p>Total: R$ {Number(total).toLocaleString('pt-BR')}</p>
      <form onSubmit={submit}>
        <h3>Shipping</h3>
        <input name="recipientName" required placeholder="Recipient" onChange={onChange} />
        <input name="street" required placeholder="Street" onChange={onChange} />
        <input name="number" required placeholder="Number" onChange={onChange} />
        <input name="city" required placeholder="City" onChange={onChange} />
        <input name="state" required placeholder="State" onChange={onChange} />
        <input name="postalCode" required placeholder="Postal code" onChange={onChange} />
        <h3>Fake Card</h3>
        <input name="printedName" required placeholder="Printed name" onChange={onChange} />
        <input name="cardNumber" required pattern="[0-9]{13,19}" placeholder="Card number" onChange={onChange} />
        <input name="expiration" required pattern="(0[1-9]|1[0-2])/[0-9]{2}" placeholder="MM/YY" onChange={onChange} />
        <input name="cvv" required pattern="[0-9]{3,4}" placeholder="CVV" onChange={onChange} />
        <input name="nickname" placeholder="Card nickname" onChange={onChange} />
        <input name="brand" placeholder="Brand" onChange={onChange} />
        <button>Place Fictional Order</button>
      </form>
      {message && <p>{message}</p>}
    </main>
  );
}
