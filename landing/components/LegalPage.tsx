import Link from "next/link";

const PAGES = [
  { href: "/data-contribution", label: "Data contribution" },
  { href: "/privacy", label: "Privacy" },
  { href: "/terms", label: "Terms of use" },
];

export default function LegalPage({
  plate,
  title,
  lede,
  current,
  children,
}: {
  plate: string;
  title: React.ReactNode;
  lede: string;
  current: string;
  children: React.ReactNode;
}) {
  return (
    <>
      {/* ══════════ NAV ══════════ */}
      <nav className="nav">
        <div className="nav-in">
          <Link className="brand" href="/">
            <img className="mark" src="/images/pathanga_logo.png" alt="Pathanga Logo" />
            <span className="wordmark">
              Pathanga<small>Butterfly India</small>
            </span>
          </Link>
          <div className="nav-links">
            {PAGES.map((p) => (
              <Link key={p.href} href={p.href} aria-current={p.href === current ? "page" : undefined}>
                {p.label}
              </Link>
            ))}
          </div>
          <Link href="/#get" className="btn btn-solid">
            Get the app
          </Link>
        </div>
      </nav>

      <section className="legal">
        <div className="wrap">
          <div className="legal-crumbs">
            <Link href="/">Pathanga</Link>
            <span aria-hidden="true">/</span>
            <span>{PAGES.find((p) => p.href === current)?.label}</span>
          </div>

          <div className="plate-head">
            <span className="no">{plate}</span>
            <div className="ttl">
              <h2>{title}</h2>
            </div>
            <span className="meta">EMPRI · Karnataka</span>
          </div>

          <p className="lede legal-lede">{lede}</p>

          <div className="legal-body">{children}</div>

          <div className="legal-jump">
            <span className="tag">Also read</span>
            <div className="legal-jump-links">
              {PAGES.filter((p) => p.href !== current).map((p) => (
                <Link key={p.href} href={p.href} className="btn">
                  {p.label}
                </Link>
              ))}
            </div>
          </div>
        </div>
      </section>

      <LegalFooter />
    </>
  );
}

export function LegalSection({ n, title, children }: { n: string; title: string; children: React.ReactNode }) {
  return (
    <section className="legal-sec">
      <div className="legal-sec-no">{n}</div>
      <div className="legal-sec-body">
        <h3>{title}</h3>
        {children}
      </div>
    </section>
  );
}

export function LegalList({ items }: { items: string[] }) {
  return (
    <ul className="legal-list">
      {items.map((i) => (
        <li key={i}>{i}</li>
      ))}
    </ul>
  );
}

function LegalFooter() {
  return (
    <footer>
      <div className="wrap">
        <div className="foot-grid">
          <div>
            <Link className="brand" href="/" style={{ marginBottom: "1rem" }}>
              <img className="mark" src="/images/pathanga_logo.png" alt="Pathanga Logo" />
              <span className="wordmark">
                Pathanga<small>Butterfly India</small>
              </span>
            </Link>
            <p style={{ color: "var(--muted)", fontSize: ".86rem", maxWidth: "34ch" }}>
              A citizen-science record of India&apos;s butterflies, built one sighting at a time.
            </p>
          </div>
          <div>
            <h5>The app</h5>
            <ul>
              <li>
                <Link href="/#features">Features</Link>
              </li>
              <li>
                <Link href="/#how">How it works</Link>
              </li>
              <li>
                <Link href="/#ai">Identification</Link>
              </li>
              <li>
                <Link href="/#showcase">App Gallery</Link>
              </li>
            </ul>
          </div>
          <div>
            <h5>Legal</h5>
            <ul>
              {PAGES.map((p) => (
                <li key={p.href}>
                  <Link href={p.href}>{p.label}</Link>
                </li>
              ))}
              <li>
                <a href="mailto:pathangaempri@gmail.com">pathangaempri@gmail.com</a>
              </li>
            </ul>
          </div>
        </div>
        <div className="foot-bottom">
          <span>© {new Date().getFullYear()} Pathanga · Butterfly India</span>
          <span>EMPRI · Government of Karnataka</span>
        </div>
      </div>
    </footer>
  );
}
