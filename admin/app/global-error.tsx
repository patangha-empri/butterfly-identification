"use client";

/**
 * Last-resort boundary: catches errors thrown by the root layout itself, which
 * app/(dashboard)/error.tsx sits below and cannot see. It replaces the whole
 * document, so it ships its own <html>/<body> and inline styles — the stylesheet
 * may be exactly what failed to load.
 */
export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <html lang="en">
      <body
        style={{
          margin: 0,
          minHeight: "100vh",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          fontFamily: "system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif",
          background: "#fafafa",
          color: "#111",
        }}
      >
        <div style={{ maxWidth: 420, padding: 24, textAlign: "center" }}>
          <h2 style={{ fontSize: 18, fontWeight: 600, margin: "0 0 8px" }}>
            The admin panel failed to start
          </h2>
          <p style={{ fontSize: 14, lineHeight: 1.5, color: "#555", margin: "0 0 20px" }}>
            This is usually a stale copy left in your browser after an update.
            Reload to fetch the current version.
          </p>
          <button
            onClick={() => window.location.reload()}
            style={{
              padding: "8px 18px",
              fontSize: 14,
              borderRadius: 8,
              border: "none",
              background: "#111",
              color: "#fff",
              cursor: "pointer",
            }}
          >
            Reload
          </button>
          <button
            onClick={reset}
            style={{
              marginLeft: 8,
              padding: "8px 18px",
              fontSize: 14,
              borderRadius: 8,
              border: "1px solid #ddd",
              background: "#fff",
              color: "#111",
              cursor: "pointer",
            }}
          >
            Try again
          </button>
        </div>
      </body>
    </html>
  );
}
