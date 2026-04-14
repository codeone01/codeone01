import { supabase } from './supabaseClient';

export async function getCatalog(filters = {}) {
  let query = supabase.from('v_catalog_products').select('*');

  if (filters.search) query = query.ilike('name', `%${filters.search}%`);
  if (filters.category) query = query.eq('category', filters.category);
  if (filters.subcategory) query = query.eq('subcategory', filters.subcategory);
  if (filters.brand) query = query.eq('brand', filters.brand);
  if (filters.type) query = query.eq('type', filters.type);
  if (filters.color) query = query.eq('color', filters.color);

  const sort = filters.sort || 'price_asc';
  if (sort === 'price_asc') query = query.order('price', { ascending: true });
  if (sort === 'price_desc') query = query.order('price', { ascending: false });
  if (sort === 'name_asc') query = query.order('name', { ascending: true });

  const { data, error } = await query;
  if (error) throw error;
  return data;
}
