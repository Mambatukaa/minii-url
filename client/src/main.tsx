import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App.tsx';
import './index.css';
import SEO from './Seo';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <SEO />
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);
