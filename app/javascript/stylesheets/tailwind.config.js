module.exports = {
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      height: {
        "5v": "5vh",
        "8v": "8vh",
        "10v": "10vh",
				"20v": "20vh",
				"30v": "30vh",
				"40v": "40vh",
				"50v": "50vh",
				"60v": "60vh",
				"70v": "70vh",
        "74v": "74vh",
				"80v": "80vh",
        "82v": "82vh",
				"90v": "90vh",
				"92v": "92vh",
        "95v": "95vh",
        "2-screen": "200vh",
      },
      minHeight: {
        '8v': '8vh',
        '10v': '10vh',
        '92v': '92vh',
        '82v': '82vh',
        '164v': '164vh',
      },
      maxHeight: {
        '100-px': '100px',
      },
      width: {
         '3/8': '37.5%',
         '5/8': '62.5%',
      },
      gridTemplateColumns: {
        "16": "repeat(16, minmax(0, 1fr))",
      },
      gridTemplateRows: {
       'layout1': '10vh minmax(0, 1fr) 10vh',
       'layout2': "10vh 30vh minmax(0, 1fr) 10vh",
      },
      gridColumn: {
         'span-13': 'span 13 / span 13',
      },
      margin: {
        '8v': '8vh',
      },
      backgroundColor: {
        'mustard': '#c89c4c',
        "mustard-50": "#f9f5ed",
      },
      borderColor: {
        'mustard': '#c89c4c',
        "mustard-100": "#f4ebdb "
      },
      textColor: {
        'mustard': '#c89c4c',
      },
      fill: theme => ({
        'red-500': theme('colors.red.500'),
        'red-700': theme('colors.red.700')
      })
    },
  },
  variants: {
    extend: {
      backgroundColor: ['active'],
      textColor: ['active'],
      fontWeight: ['active'],
    },
  },
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('tailwind-scrollbar-hide')
  ],
}