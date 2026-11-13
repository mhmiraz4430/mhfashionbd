-- MH Fashion: customer order permission repair (NO bKash/Nagad changes)
-- Run once in Supabase SQL Editor. Does not grant anon SELECT on orders.

grant usage on schema public to anon, authenticated;
grant insert on table public.orders to anon, authenticated;
grant select, update on table public.orders to authenticated;

alter table public.orders enable row level security;

drop policy if exists "Customers can place orders" on public.orders;
create policy "Customers can place orders"
on public.orders
for insert
to anon, authenticated
with check (
  char_length(customer_name) between 2 and 100
  and char_length(phone) between 10 and 16
  and char_length(address) between 5 and 500
  and jsonb_typeof(items) = 'array'
  and total >= 0
);
