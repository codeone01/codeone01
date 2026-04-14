import React, { useEffect } from 'react';
import $ from 'jquery';

export default function HomePage() {
  useEffect(() => {
    const interval = setInterval(() => {
      $('.hero h1').fadeOut(250).fadeIn(250);
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  return (
    <main className="page">
      <section className="hero">
        <h1>Ucan Luxury Universe</h1>
        <p>Exclusive fictional commerce for premium lifestyles.</p>
      </section>
    </main>
  );
}
