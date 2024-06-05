import withMT from '@material-tailwind/html/utils/withMT';

/** @type {import('tailwindcss').Config} */
export default withMT({
  content: ['./src/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      backgroundImage: {
        'bg-1': "url('assets/background/bg-1.jpg')",
        'bg-2': "url('assets/background/bg-2.jpg')",
        'bg-3': "url('assets/background/bg-3.jpg')",
        'bg-4': "url('assets/background/bg-3.jpg')",
        'bg-5': "url('assets/background/bg-3.jpg')",
        'bg-6': "url('assets/background/bg-6.jpg')"
      },
      animation: {
        border: 'border 4s ease infinite'
      },
      keyframes: {
        border: {
          '0%, 100%': { backgroundPosition: '0% 50%' },
          '50%': { backgroundPosition: '100% 50%' }
        }
      }
    }
  },
  fontFamily: {},
  plugins: []
});
