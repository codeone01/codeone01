import React, { useEffect, useState } from 'react';
import { Navigate } from 'react-router-dom';
import { supabase } from '../services/supabaseClient';
import { useAuth } from '../context/AuthContext';

export default function HiddenAdminGate({ children }) {
  const { session } = useAuth();
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function check() {
      if (!session?.user?.id) return setLoading(false);
      const { data } = await supabase.from('user_roles').select('role').eq('user_id', session.user.id).eq('role', 'admin').maybeSingle();
      setIsAdmin(Boolean(data));
      setLoading(false);
    }
    check();
  }, [session?.user?.id]);

  if (loading) return <p className="page">Loading...</p>;
  if (!isAdmin) return <Navigate to="/" replace />;
  return children;
}
