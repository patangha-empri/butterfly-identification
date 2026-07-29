"use client";

import { useEffect, useState } from "react";
import { Butterfly } from "./ButterflyFlyers";

export default function FlightPathButterfly() {
  const [offsetPath, setOffsetPath] = useState<string>("");
  const [ready, setReady] = useState(false);

  useEffect(() => {


    function syncFlightPath() {
      const host = document.querySelector(".flight");
      const svgPath = document.querySelector(".path-svg path") as SVGPathElement | null;
      if (!host || !svgPath) return;

      const ctm = svgPath.getScreenCTM();
      if (!ctm) return; // Hidden at this breakpoint or not loaded

      const box = host.getBoundingClientRect();
      const len = svgPath.getTotalLength();
      const STEPS = 72;
      let d = "";

      for (let i = 0; i <= STEPS; i++) {
        const p = svgPath.getPointAtLength((len * i) / STEPS).matrixTransform(ctm);
        const x = (p.x - box.left).toFixed(1);
        const y = (p.y - box.top).toFixed(1);
        d += (i ? " L" : "M") + x + "," + y;
      }

      setOffsetPath(`path("${d}")`);
      setReady(true);
    }

    // Initial sync after rendering has settled
    const initialTimeout = setTimeout(syncFlightPath, 100);

    // Debounced resize handler
    let resizeTimeout: NodeJS.Timeout;
    const handleResize = () => {
      clearTimeout(resizeTimeout);
      resizeTimeout = setTimeout(syncFlightPath, 160);
    };

    window.addEventListener("resize", handleResize);

    // Sync on font load to make sure dimensions are final
    if (document.fonts) {
      document.fonts.ready.then(syncFlightPath);
    }

    return () => {
      window.removeEventListener("resize", handleResize);
      clearTimeout(initialTimeout);
      clearTimeout(resizeTimeout);
    };
  }, []);

  if (!offsetPath) return null;

  return (
    <div
      id="pathfly"
      className={`pathfly ${ready ? "ready" : ""}`}
      style={{ offsetPath } as React.CSSProperties}
      aria-hidden="true"
    >
      <Butterfly colors={["#FF8A3D", "#E8B84B", "#F4EEE3"]} flap="0.36" gradId="g-pathfly" />
    </div>
  );
}
