const API_BASE = import.meta.env.VITE_API_BASE_URL;

export async function placeOrder(accessToken, payload) {
  const response = await fetch(`${API_BASE}/checkout/orders`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${accessToken}`
    },
    body: JSON.stringify(payload)
  });

  if (!response.ok) throw new Error('Order placement failed');
  return response.json();
}
