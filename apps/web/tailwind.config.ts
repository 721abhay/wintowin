import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        ink: "#14161C",
        "ink-muted": "#5B6070",
        canvas: "#F6F4EF",
        surface: "#FFFFFF",
        line: "#E2DFD6",
        primary: {
          DEFAULT: "#0E7A5F",
          dark: "#0A5C47",
          light: "#E7F3EF",
        },
        "win-gold": {
          DEFAULT: "#F2A900",
          light: "#FEF7E6",
        },
        danger: "#C62828",
        warning: "#B26A00",
      },
      fontFamily: {
        sans: ["var(--font-sora)", "system-ui", "-apple-system", "sans-serif"],
        mono: ["var(--font-mono)", "monospace"],
      },
    },
  },
  plugins: [],
};
export default config;
