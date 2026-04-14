import React, { useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { supabase } from '../services/supabaseClient';

export default function DashboardPage() {
  const { session } = useAuth();
  const [balance, setBalance] = useState(0);
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    async function load() {
      if (!session?.user?.id) return;
      const { data: b } = await supabase.from('user_balances').select('balance').eq('user_id', session.user.id).single();
      const { data: o } = await supabase.from('orders').select('*').eq('user_id', session.user.id).order('created_at', { ascending: false });
      setBalance(b?.balance || 0);
      setOrders(o || []);
    }
    load();
  }, [session?.user?.id]);

  return (
    <main className="page">
      <h2>User Dashboard</h2>
      <p>Fictional Balance: <strong>R$ {Number(balance).toLocaleString('pt-BR')}</strong></p>
      <h3>Orders</h3>
      <ul>{orders.map((o) => <li key={o.id}>#{o.id} — {o.status} — R$ {Number(o.total_amount).toLocaleString('pt-BR')}</li>)}</ul>
    </main>
  );
}
