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
				"80v": "80vh",
				"90v": "90vh",
				"92v": "92vh",
        "95v": "95vh",
      },
      gridTemplateColumns: {
        "16": "repeat(16, minmax(0, 1fr))",
      },
      gridTemplateRows: {
       'layout1': '10vh minmax(0, 1fr) 8vh',
      }
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
    require('@tailwindcss/aspect-ratio')
  ],
}
