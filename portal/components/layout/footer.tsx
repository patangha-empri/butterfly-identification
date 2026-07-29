import Link from "next/link";

export function Footer() {
  return (
    <footer className="border-t bg-muted/30 mt-auto">
      <div className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
          <div>
            <div className="flex items-center gap-2 font-bold mb-2">
              <span className="text-xl">🦋</span>
              <span>Butterfly India</span>
            </div>
            <p className="text-xs text-muted-foreground leading-relaxed">
              A citizen science platform for tracking and identifying butterfly species across India.
            </p>
          </div>
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide mb-2">Explore</p>
            <ul className="space-y-1">
              {[
                { href: "/sightings", label: "Sightings Map" },
                { href: "/species", label: "Species Guide" },
                { href: "/articles", label: "Learn" },
              ].map(({ href, label }) => (
                <li key={href}>
                  <Link href={href} className="text-xs text-muted-foreground hover:text-foreground transition-colors">
                    {label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide mb-2">Contribute</p>
            <ul className="space-y-1">
              {[
                { href: "/submit", label: "Submit a Sighting" },
                { href: "/register", label: "Join the community" },
                { href: "/my-sightings", label: "My Sightings" },
              ].map(({ href, label }) => (
                <li key={href}>
                  <Link href={href} className="text-xs text-muted-foreground hover:text-foreground transition-colors">
                    {label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        </div>
        <div className="mt-6 pt-4 border-t text-center text-xs text-muted-foreground">
          India Butterfly Census • Citizen Science Biodiversity Platform
        </div>
      </div>
    </footer>
  );
}
