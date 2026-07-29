"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  Users,
  Leaf,
  Binoculars,
  Cpu,
  FileText,
  Flag,
  ChevronRight,
  Radio,
} from "lucide-react";
import { cn } from "@/lib/utils";

// Binoculars might not be in lucide-react — fallback to Eye
import { Eye } from "lucide-react";

const navItems = [
  { href: "/dashboard", label: "Dashboard", icon: LayoutDashboard, exact: true },
  { href: "/users", label: "Users", icon: Users },
  { href: "/species", label: "Species", icon: Leaf },
  { href: "/observations", label: "Observations", icon: Eye },
  { href: "/identifications", label: "Identification Log", icon: Cpu },
  { href: "/broadcast", label: "Broadcast", icon: Radio },
  { href: "/reports", label: "Reports", icon: Flag },
];

interface SidebarProps {
  className?: string;
  onNavClick?: () => void;
}

export function Sidebar({ className, onNavClick }: SidebarProps) {
  const pathname = usePathname();

  function isActive(href: string, exact?: boolean) {
    if (exact) return pathname === href;
    return pathname.startsWith(href);
  }

  return (
    <aside className={cn("flex flex-col h-full bg-sidebar border-r border-sidebar-border", className)}>
      {/* Logo */}
      <div className="flex items-center gap-2.5 px-4 h-14 border-b border-sidebar-border shrink-0">
        <img src="/pathanga-logo.png" alt="Pathanga — EMPRI" className="h-9 w-auto" />
        <div>
          <p className="text-sm font-semibold text-sidebar-foreground leading-tight">Pathanga Admin</p>
          <p className="text-[10px] text-sidebar-foreground/50 leading-tight">EMPRI · Biodiversity Platform</p>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 overflow-y-auto py-3 px-2 space-y-0.5">
        {navItems.map(({ href, label, icon: Icon, exact }) => {
          const active = isActive(href, exact);
          return (
            <Link
              key={href}
              href={href}
              onClick={onNavClick}
              className={cn(
                "flex items-center gap-3 px-3 py-2 rounded-lg text-sm font-medium transition-colors group",
                active
                  ? "bg-sidebar-primary text-sidebar-primary-foreground"
                  : "text-sidebar-foreground hover:bg-sidebar-accent hover:text-sidebar-accent-foreground"
              )}
            >
              <Icon
                size={16}
                className={cn(
                  "shrink-0",
                  active
                    ? "text-sidebar-primary-foreground"
                    : "text-sidebar-foreground/60 group-hover:text-sidebar-accent-foreground"
                )}
              />
              <span className="flex-1">{label}</span>
              {active && (
                <ChevronRight size={14} className="text-sidebar-primary-foreground/60" />
              )}
            </Link>
          );
        })}
      </nav>

      {/* Footer */}
      <div className="px-4 py-3 border-t border-sidebar-border shrink-0">
        <p className="text-[10px] text-sidebar-foreground/40">Pathanga • EMPRI • v1.0</p>
      </div>
    </aside>
  );
}
