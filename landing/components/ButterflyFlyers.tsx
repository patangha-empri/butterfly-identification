"use client";

import { useEffect, useState } from "react";

const SPECIES_COLOURS = [
  ["#FF8A3D", "#E8B84B", "#F4EEE3"], // Great Orange Tip
  ["#4A90E2", "#2D9E82", "#F4EEE3"], // Blue Tiger
  ["#E8B84B", "#FF8A3D", "#2a2118"], // Common Jezebel
  ["#9B59B6", "#4A90E2", "#F4EEE3"], // Blue Mormon
  ["#2D9E82", "#1F6E5A", "#E8B84B"], // Common Jay
  ["#E74C3C", "#FF8A3D", "#2a2118"], // Plain Tiger
];

interface FlyerData {
  id: string;
  size: string;
  dur: string;
  delay: string;
  top: string;
  opacity: number;
  colors: string[];
  flap: string;
  gradId: string;
}

export function Butterfly({ colors, flap, gradId }: { colors: string[]; flap: string; gradId: string }) {
  const [a, b, c] = colors;

  return (
    <svg
      className="bfly"
      viewBox="0 0 120 100"
      width="100%"
      height="100%"
      style={{ "--flap": `${flap}s` } as React.CSSProperties}
      aria-hidden="true"
    >
      <defs>
        <linearGradient id={gradId} x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stopColor={a} />
          <stop offset="100%" stopColor={b} />
        </linearGradient>
      </defs>
      <g className="w wl">
        <path d="M59,33 C50,17 30,3 14,7 C2,10 1,32 13,44 C25,55 48,54 58,50 Z" fill={`url(#${gradId})`} />
        <path d="M14,7 C2,10 1,32 13,44 C22,51 34,53 43,52 C31,40 20,24 14,7 Z" fill={c} opacity=".85" />
        <path d="M58,52 C44,54 25,58 19,69 C13,81 26,93 38,88 C50,83 57,67 59,56 Z" fill={b} />
        <circle cx="33" cy="72" r="4.2" fill={c} opacity=".9" />
        <path d="M57,36 C44,32 28,22 16,11" stroke="rgba(20,14,6,.22)" strokeWidth="1.1" fill="none" />
        <path d="M57,56 C46,61 33,67 24,75" stroke="rgba(20,14,6,.22)" strokeWidth="1.1" fill="none" />
      </g>
      <g transform="translate(120,0) scale(-1,1)">
        <g className="w wr">
          <path d="M59,33 C50,17 30,3 14,7 C2,10 1,32 13,44 C25,55 48,54 58,50 Z" fill={`url(#${gradId})`} />
          <path d="M14,7 C2,10 1,32 13,44 C22,51 34,53 43,52 C31,40 20,24 14,7 Z" fill={c} opacity=".85" />
          <path d="M58,52 C44,54 25,58 19,69 C13,81 26,93 38,88 C50,83 57,67 59,56 Z" fill={b} />
          <circle cx="33" cy="72" r="4.2" fill={c} opacity=".9" />
          <path d="M57,36 C44,32 28,22 16,11" stroke="rgba(20,14,6,.22)" strokeWidth="1.1" fill="none" />
          <path d="M57,56 C46,61 33,67 24,75" stroke="rgba(20,14,6,.22)" strokeWidth="1.1" fill="none" />
        </g>
      </g>
      <ellipse cx="60" cy="54" rx="3" ry="21" fill="#1c1710" />
      <path d="M60,34 C56,24 50,18 44,15" stroke="#1c1710" strokeWidth="1.5" fill="none" strokeLinecap="round" />
      <path d="M60,34 C64,24 70,18 76,15" stroke="#1c1710" strokeWidth="1.5" fill="none" strokeLinecap="round" />
    </svg>
  );
}

export default function ButterflyFlyers({ host }: { host: "hero" | "download" }) {
  const [flyers, setFlyers] = useState<FlyerData[]>([]);

  useEffect(() => {


    const count = host === "hero" ? 6 : 4;
    const hostIdx = host === "hero" ? 0 : 1;
    const generated: FlyerData[] = [];

    for (let i = 0; i < count; i++) {
      const colors = SPECIES_COLOURS[(i + hostIdx * 2) % SPECIES_COLOURS.length];
      generated.push({
        id: `${host}-${i}`,
        size: (34 + Math.random() * 44).toFixed(0) + "px",
        dur: (22 + Math.random() * 22).toFixed(1) + "s",
        delay: (-Math.random() * 30).toFixed(1) + "s",
        top: (8 + Math.random() * 68).toFixed(0) + "%",
        opacity: Number((0.5 + Math.random() * 0.45).toFixed(2)),
        colors,
        flap: (0.32 + Math.random() * 0.34).toFixed(2),
        gradId: `g-${host}-${i}`,
      });
    }

    setFlyers(generated);
  }, [host]);

  return (
    <>
      {flyers.map((f) => (
        <div
          key={f.id}
          className="flyer"
          style={
            {
              "--size": f.size,
              "--dur": f.dur,
              "--delay": f.delay,
              top: f.top,
              opacity: f.opacity,
            } as React.CSSProperties
          }
        >
          <Butterfly colors={f.colors} flap={f.flap} gradId={f.gradId} />
        </div>
      ))}
    </>
  );
}
