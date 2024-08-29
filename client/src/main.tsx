import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import App from './App.tsx';
import './index.css';
import SEO from './Seo';
import RedirectHandler from './RedirectHandler';
import About from './About.tsx';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <SEO />
    <BrowserRouter>
      <Routes>
        <Route path="/" Component={App} />
        <Route path="/:id" Component={RedirectHandler} />
        <Route path="/about" Component={About} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
