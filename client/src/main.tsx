import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter, Route, Routes } from 'react-router-dom';
import App from './App.tsx';
import './index.css';
import RedirectHandler from './RedirectHandler';
import NotFound from './NotFound.tsx';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" Component={App} />
        <Route path="/:id" Component={RedirectHandler} />
        <Route path="/not-found" Component={NotFound} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
