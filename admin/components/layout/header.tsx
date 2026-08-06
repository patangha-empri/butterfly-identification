"use client";

import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { AppLink } from "@/components/shared/app-link";
import { Menu, LogOut, User as UserIcon } from "lucide-react";
import { toast } from "sonner";

import api from "@/lib/api";
import { getCurrentUser, clearAuth } from "@/lib/auth";
import { appUrl, normalizePath } from "@/lib/navigation";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import { Sidebar } from "./sidebar";
import type { User } from "@/types";

// Map path segments to readable titles
const PAGE_TITLES: Record<string, string> = {
  "": "Dashboard",
  dashboard: "Dashboard",
  users: "Users",
  species: "Species",
  observations: "Observations",
  identifications: "Identification Log",
  broadcast: "Broadcast",
  reports: "Reports",
  profile: "My Profile",
};

function getPageTitle(pathname: string): string {
  // trailingSlash: true means usePathname() yields "/users/" — normalize first.
  const segment = normalizePath(pathname).split("/")[1] ?? "";
  return PAGE_TITLES[segment] ?? "Dashboard";
}

export function Header() {
  const pathname = usePathname();
  const [user, setUser] = useState<User | null>(null);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    setUser(getCurrentUser());
  }, [pathname]);

  const [signingOut, setSigningOut] = useState(false);

  async function handleLogout() {
    if (signingOut) return;
    setSigningOut(true);

    // Tell the backend first — JWTs are stateless here, so this is advisory
    // (it records the event), and it must not be able to strand the user in a
    // signed-in UI. Clear locally no matter how it goes.
    try {
      await api.post("/auth/logout");
    } catch {
      // Offline, or the token already expired. Either way we're signing out.
    }

    clearAuth();
    toast.success("Signed out successfully.");
    // replace(), not href: the dashboard must not be one Back press away with
    // a dead token, which would just render the guard's blank screen.
    window.location.replace(appUrl("/login"));
  }

  const initials = user?.full_name
    ?.split(" ")
    .map((n) => n[0])
    .slice(0, 2)
    .join("")
    .toUpperCase() ?? "A";

  return (
    <header className="flex h-14 items-center gap-3 border-b bg-background px-4 shrink-0">
      {/* Mobile menu trigger */}
      <Sheet open={mobileOpen} onOpenChange={setMobileOpen}>
        <SheetTrigger asChild>
          <Button variant="ghost" size="icon" className="md:hidden">
            <Menu size={18} />
          </Button>
        </SheetTrigger>
        <SheetContent side="left" className="p-0 w-60">
          <SheetTitle className="sr-only">Navigation menu</SheetTitle>
          <SheetDescription className="sr-only">
            Main navigation links for the admin dashboard
          </SheetDescription>
          <Sidebar onNavClick={() => setMobileOpen(false)} className="h-full" />
        </SheetContent>
      </Sheet>

      {/* Page title */}
      <h1 className="text-sm font-semibold flex-1">{getPageTitle(pathname)}</h1>

      {/* User menu */}
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="icon" className="rounded-full size-8">
            <Avatar className="size-7">
              <AvatarImage src={user?.profile_image_url} alt={user?.full_name} />
              <AvatarFallback className="text-xs">{initials}</AvatarFallback>
            </Avatar>
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-52">
          <DropdownMenuLabel className="font-normal">
            <p className="font-medium text-sm">{user?.full_name ?? "Admin"}</p>
            <p className="text-xs text-muted-foreground capitalize">{user?.role ?? ""}</p>
          </DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem asChild>
            <AppLink href="/profile" className="gap-2">
              <UserIcon size={14} />
              Profile
            </AppLink>
          </DropdownMenuItem>
          <DropdownMenuSeparator />
          <DropdownMenuItem
            onClick={(e) => {
              // Keep the menu open while the logout request is in flight, so
              // the item can't be clicked a second time mid-sign-out.
              e.preventDefault();
              void handleLogout();
            }}
            disabled={signingOut}
            className="gap-2 text-destructive focus:text-destructive"
          >
            <LogOut size={14} />
            {signingOut ? "Signing out…" : "Sign out"}
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </header>
  );
}
