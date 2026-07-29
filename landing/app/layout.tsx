import type { Metadata } from "next";
import { Bodoni_Moda, Karla, Space_Mono } from "next/font/google";
import "./globals.css";

const bodoniModa = Bodoni_Moda({
  subsets: ["latin"],
  variable: "--font-display",
  display: "swap",
});

const karla = Karla({
  subsets: ["latin"],
  variable: "--font-body",
  display: "swap",
});

const spaceMono = Space_Mono({
  weight: ["400", "700"],
  subsets: ["latin"],
  variable: "--font-mono",
  display: "swap",
});

export const metadata: Metadata = {
  title: "Pathanga — Identify India's Butterflies",
  description: "Pathanga turns your phone into a field lab. Photograph a butterfly, get an AI identification in seconds, and log a sighting that becomes real biodiversity data.",
  other: {
    "theme-color": "#08110D",
  },
  openGraph: {
    title: "Pathanga — Identify India's Butterflies",
    description: "AI identification, a 1,500-species field guide, and offline sighting logs. Free, for every naturalist in India.",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      cz-shortcut-listen="true"
      className={`${bodoniModa.variable} ${karla.variable} ${spaceMono.variable} scroll-smooth`}
    >
      <body className="antialiased">{children}</body>
    </html>
  );
}
