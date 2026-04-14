-- 7) Luxury seed data (categories, subcategories, products)

insert into categories(name, slug) values
('Nautical','nautical'),
('Automobiles','automobiles'),
('Aerospace','aerospace'),
('Watches','watches'),
('Arts','arts'),
('Jewelry','jewelry'),
('Fashion','fashion'),
('Real Estate','real-estate'),
('Furniture','furniture'),
('Electronics','electronics'),
('Perfumery','perfumery'),
('Travel and Experiences','travel-experiences'),
('Luxury Decor','luxury-decor'),
('Premium Writing and Office','premium-writing-office'),
('Collectibles','collectibles')
on conflict do nothing;

insert into subcategories(category_id, name, slug)
select c.id, s.name, s.slug
from categories c
join (
  values
  ('Nautical','Boats','boats'),('Nautical','Yachts','yachts'),('Nautical','Jet Skis','jet-skis'),('Nautical','Speedboats','speedboats'),('Nautical','Catamarans','catamarans'),
  ('Automobiles','Cars','cars'),('Automobiles','Motorcycles','motorcycles'),('Automobiles','Luxury SUVs','luxury-suvs'),('Automobiles','Sports Cars','sports-cars'),('Automobiles','Collectible Classics','collectible-classics'),
  ('Aerospace','Executive Jets','executive-jets'),('Aerospace','Helicopters','helicopters'),('Aerospace','Light Aircraft','light-aircraft'),
  ('Watches','Swiss Watches','swiss-watches'),('Watches','Luxury Sports Watches','luxury-sports-watches'),('Watches','Classic Watches','classic-watches'),('Watches','Limited Editions','limited-editions'),('Watches','Premium Smartwatches','premium-smartwatches'),
  ('Jewelry','Rings','rings'),('Jewelry','Necklaces','necklaces'),('Jewelry','Bracelets','bracelets'),('Jewelry','Earrings','earrings'),('Jewelry','High Jewelry','high-jewelry'),
  ('Fashion','Dresses','dresses'),('Fashion','Suits','suits'),('Fashion','Premium Shirts','premium-shirts'),('Fashion','Jackets','jackets'),('Fashion','Shoes','shoes'),('Fashion','Handbags','handbags'),
  ('Real Estate','Mansions','mansions'),('Real Estate','Penthouses','penthouses'),('Real Estate','Luxury Apartments','luxury-apartments'),('Real Estate','Beach Houses','beach-houses'),('Real Estate','Private Islands','private-islands'),
  ('Furniture','Premium Sofas','premium-sofas'),('Furniture','Designer Tables','designer-tables'),('Furniture','Signature Chairs','signature-chairs'),('Furniture','Luxury Beds','luxury-beds'),('Furniture','Lighting','lighting'),
  ('Electronics','Premium TVs','premium-tvs'),('Electronics','Audio Systems','audio-systems'),('Electronics','Luxury Smartphones','luxury-smartphones'),('Electronics','Premium Laptops','premium-laptops'),('Electronics','Home Automation','home-automation'),
('Arts','Paintings','paintings'),('Perfumery','Niche Fragrances','niche-fragrances'),('Travel and Experiences','Private Expeditions','private-expeditions'),('Luxury Decor','Statement Decor','statement-decor'),('Premium Writing and Office','Writing Instruments','writing-instruments'),('Collectibles','Timepiece Memorabilia','timepiece-memorabilia')
) as s(category_name, name, slug)
on c.name = s.category_name
on conflict do nothing;

insert into brands(name)
values ('Aurelia'),('Velmont'),('Orion Elite'),('Celestia'),('Imperium'),('Monarch Maison'),('Helios Crafted')
on conflict do nothing;

insert into product_types(name)
values ('Limited'),('Signature'),('Collector'),('Flagship'),('Bespoke')
on conflict do nothing;

insert into colors(name, hex_code)
values ('Onyx','#0f0f0f'),('Pearl','#f8f6f0'),('Sapphire','#0f52ba'),('Emerald','#009b77'),('Ruby','#9b111e'),('Platinum','#e5e4e2')
on conflict do nothing;

-- Product seeds across multiple luxury segments
with refs as (
  select
    (select id from brands where name = 'Aurelia') as brand_id,
    (select id from product_types where name = 'Flagship') as type_id,
    (select id from colors where name = 'Onyx') as color_id
)
insert into products(name, category_id, subcategory_id, brand_id, product_type_id, color_id, price, short_description, long_description, specifications, stock, premium_badge, featured, fictional_delivery_time)
select
  p.name,
  (select id from categories where name = p.category_name),
  (select id from subcategories where name = p.subcategory_name limit 1),
  coalesce((select id from brands where name = p.brand_name), (select brand_id from refs)),
  (select type_id from refs),
  (select color_id from refs),
  p.price,
  p.short_desc,
  p.long_desc,
  p.specs::jsonb,
  p.stock,
  true,
  p.featured,
  p.delivery
from (
  values
  ('Aurelia Sea Phantom 48','Nautical','Yachts','Aurelia',12500000.00,'Ocean class craft with couture interior.','Hand-built hull, concierge-ready command deck, and panoramic owner suite.','{"length":"48m","crew":"12","range":"4500nm"}',2,true,'30-45 dias'),
  ('Velmont V12 Royale','Automobiles','Sports Cars','Velmont',6200000.00,'Hyper-luxury sports coupe.','Carbon monocoque architecture and handcrafted interior in full-grain leather.','{"power":"980hp","0-100":"2.8s","drivetrain":"AWD"}',5,true,'20-30 dias'),
  ('Orion Executive X','Aerospace','Executive Jets','Orion Elite',89000000.00,'Ultra-long range private jet.','Cabin architecture for 14 guests with silent-flight insulation.','{"range":"12000km","capacity":"14","max_speed":"Mach 0.9"}',1,true,'60-120 dias'),
  ('Celestia Chronograph No.8','Watches','Swiss Watches','Celestia',450000.00,'Swiss complication with sapphire back.','Limited workshop release with tourbillon and annual calendar.','{"movement":"Automatic","case":"Platinum","water_resistance":"100m"}',20,true,'7-12 dias'),
  ('Aurelia Gallery Masterpiece','Arts','Paintings','Aurelia',950000.00,'Curated contemporary canvas.','Museum-grade archival pigments and signed provenance package.','{"size":"200x140cm","medium":"Oil on canvas"}',4,true,'5-9 dias'),
  ('Imperium Radiant Ring','Jewelry','Rings','Imperium',125000.00,'High jewelry diamond ring.','Laboratory-certified stones with bespoke cut geometry.','{"material":"18k gold","stones":"VVS1 diamond","weight":"12g"}',15,false,'5-10 dias'),
  ('Monarch Atelier Suit','Fashion','Suits','Monarch Maison',38000.00,'Tailored ceremonial suit.','Bespoke fit with hand-stitched internal canvas and silk lining.','{"fabric":"Super 180s wool","fit":"Bespoke","origin":"Italy"}',30,false,'10-14 dias'),
  ('Helios Sky Penthouse 01','Real Estate','Penthouses','Helios Crafted',250000000.00,'Prime skyline penthouse.','Private elevator, rooftop pool and concierge services.','{"area":"1500m2","rooms":"6","garage":"8"}',1,true,'90-180 dias'),
  ('Aurelia Sonata Sofa','Furniture','Premium Sofas','Aurelia',89000.00,'Designer modular sofa.','Italian craftsmanship with premium suede and modular silhouette.','{"modules":"5","material":"Suede","warranty":"10 years"}',12,false,'15-25 dias'),
  ('Velmont Vision 98"','Electronics','Premium TVs','Velmont',145000.00,'Flagship cinematic display.','MicroLED architecture with calibrated luxury cinema profile.','{"size":"98 inches","resolution":"8K","audio":"Dolby Atmos"}',10,true,'7-10 dias'),
  ('Celestia Nuit Extrait','Perfumery','Niche Fragrances','Celestia',4200.00,'Nocturnal artisanal extrait.','Rare oud accords with saffron and smoked amber depth.','{"volume":"100ml","family":"Oriental Woody"}',120,false,'3-5 dias'),
  ('Orion Arctic Expedition','Travel and Experiences','Private Expeditions','Orion Elite',980000.00,'Private polar expedition.','All-inclusive guided experience with bespoke itinerary and luxury lodge.','{"duration":"12 days","guests":"8","season":"Winter"}',8,true,'Sob consulta'),
  ('Imperium Crystal Chandelier','Luxury Decor','Statement Decor','Imperium',76000.00,'Statement crystal lighting.','Hand-cut crystal strands with programmable ambient scenes.','{"height":"180cm","material":"Crystal & brass"}',9,false,'12-20 dias'),
  ('Monarch Heritage Fountain Pen','Premium Writing and Office','Writing Instruments','Monarch Maison',18500.00,'Collector writing instrument.','Resin and palladium body with precision gold nib.','{"nib":"18k gold","edition":"500 units"}',60,false,'4-8 dias'),
  ('Helios Vintage Chronometer 1959','Collectibles','Timepiece Memorabilia','Helios Crafted',325000.00,'Curated historical collectible.','Authenticated provenance with protective museum-grade casing.','{"year":"1959","certificate":"Included"}',3,true,'7-14 dias')
) as p(name, category_name, subcategory_name, brand_name, price, short_desc, long_desc, specs, stock, featured, delivery)
on conflict do nothing;

insert into product_images(product_id, image_url, sort_order)
select id, 'https://placehold.co/1200x900?text=' || replace(name, ' ', '+'), 1
from products
on conflict do nothing;

insert into product_videos(product_id, video_url, sort_order)
select id, 'https://example.com/video/' || id, 1
from products
on conflict do nothing;
