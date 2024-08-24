import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from 'tailwindcss';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: 'client/dist/',
  css: {
    postcss: {
      plugins: [tailwindcss()]
    }
  },
  server: {
    open: true,
    port: 3000
  }
});
