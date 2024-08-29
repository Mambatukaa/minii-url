import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import App from './App.tsx';
import './index.css';
import SEO from './Seo';
import RedirectHandler from './RedirectHandler';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <SEO />
    <BrowserRouter>
      <Routes>
        <Route path="/" Component={App} />
        <Route path="/:id" Component={RedirectHandler} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
