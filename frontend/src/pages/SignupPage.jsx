import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';

export default function SignupPage() {
  const { signup } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  async function onSubmit(e) {
    e.preventDefault();
    await signup(email, password);
    setMessage('Account created. Please verify your email to unlock bonus balance.');
  }

  return (
    <main className="page form-wrap">
      <h2>Create account</h2>
      <form onSubmit={onSubmit}>
        <input type="email" required placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} />
        <input type="password" required minLength={8} placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} />
        <button>Create</button>
      </form>
      {message && <p>{message}</p>}
    </main>
  );
}
