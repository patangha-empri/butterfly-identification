"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { Menu, LogOut, User as UserIcon, PlusCircle, Binoculars } from "lucide-react";
import { toast } from "sonner";
import { cn } from "@/lib/utils";
import { getCurrentUser, clearAuth, isLoggedIn } from "@/lib/auth";
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
import { Sheet, SheetContent, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import type { User } from "@/types";

const NAV_LINKS = [
  { href: "/sightings", label: "Sightings" },
  { href: "/species", label: "Species" },
  { href: "/articles", label: "Learn" },
];

export function Navbar() {
  const pathname = usePathname();
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [loggedIn, setLoggedIn] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    setLoggedIn(isLoggedIn());
    setUser(getCurrentUser());
  }, [pathname]);

  function handleLogout() {
    clearAuth();
    setUser(null);
    setLoggedIn(false);
    toast.success("Signed out.");
    router.push("/");
  }

  const initials =
    user?.full_name
      ?.split(" ")
      .map((n) => n[0])
      .slice(0, 2)
      .join("")
      .toUpperCase() ?? "U";

  return (
    <header className="sticky top-0 z-50 border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto px-4 h-14 flex items-center gap-4">
        {/* Logo */}
        <Link href="/" className="flex items-center gap-2 font-bold text-base shrink-0">
          <span className="text-2xl">🦋</span>
          <span className="hidden sm:inline">Butterfly India</span>
        </Link>

        {/* Desktop nav */}
        <nav className="hidden md:flex items-center gap-1 flex-1">
          {NAV_LINKS.map(({ href, label }) => (
            <Link
              key={href}
              href={href}
              className={cn(
                "px-3 py-1.5 text-sm rounded-md transition-colors",
                pathname.startsWith(href)
                  ? "bg-primary/10 text-primary font-medium"
                  : "text-muted-foreground hover:text-foreground hover:bg-muted"
              )}
            >
              {label}
            </Link>
          ))}
        </nav>

        {/* Right side */}
        <div className="ml-auto flex items-center gap-2">
          <Button asChild size="sm" className="hidden md:inline-flex gap-1.5">
            <Link href="/submit">
              <PlusCircle size={15} />
              Submit Sighting
            </Link>
          </Button>

          {loggedIn && user ? (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="rounded-full size-8">
                  <Avatar className="size-7">
                    <AvatarImage src={user.profile_image_url ?? undefined} />
                    <AvatarFallback className="text-xs">{initials}</AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-48">
                <DropdownMenuLabel className="font-normal">
                  <p className="font-medium text-sm truncate">{user.full_name}</p>
                  <p className="text-xs text-muted-foreground truncate">@{user.username}</p>
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <DropdownMenuItem asChild>
                  <Link href="/my-sightings" className="gap-2 cursor-pointer">
                    <Binoculars size={14} />
                    My Sightings
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuItem asChild>
                  <Link href="/profile" className="gap-2 cursor-pointer">
                    <UserIcon size={14} />
                    Profile
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem
                  onClick={handleLogout}
                  className="gap-2 text-destructive focus:text-destructive cursor-pointer"
                >
                  <LogOut size={14} />
                  Sign out
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          ) : (
            <Button variant="ghost" size="sm" asChild>
              <Link href="/login">Sign in</Link>
            </Button>
          )}

          {/* Mobile hamburger */}
          <Sheet open={mobileOpen} onOpenChange={setMobileOpen}>
            <SheetTrigger asChild>
              <Button variant="ghost" size="icon" className="md:hidden">
                <Menu size={18} />
              </Button>
            </SheetTrigger>
            <SheetContent side="right" className="w-64 p-0">
              {/* Visually hidden title required by Radix for screen reader accessibility */}
              <SheetTitle className="sr-only">Navigation Menu</SheetTitle>
              <div className="flex flex-col h-full p-4 gap-2 pt-14">
                {NAV_LINKS.map(({ href, label }) => (
                  <Link
                    key={href}
                    href={href}
                    onClick={() => setMobileOpen(false)}
                    className={cn(
                      "px-3 py-2 text-sm rounded-md transition-colors",
                      pathname.startsWith(href)
                        ? "bg-primary/10 text-primary font-medium"
                        : "text-muted-foreground hover:text-foreground hover:bg-muted"
                    )}
                  >
                    {label}
                  </Link>
                ))}
                <hr className="my-2" />
                <Link
                  href="/submit"
                  onClick={() => setMobileOpen(false)}
                  className="flex items-center gap-2 px-3 py-2 text-sm rounded-md bg-primary text-primary-foreground"
                >
                  <PlusCircle size={14} />
                  Submit Sighting
                </Link>
                <hr className="my-2" />
                {/* Auth links in mobile drawer */}
                {loggedIn && user ? (
                  <>
                    <Link
                      href="/my-sightings"
                      onClick={() => setMobileOpen(false)}
                      className="flex items-center gap-2 px-3 py-2 text-sm rounded-md text-muted-foreground hover:text-foreground hover:bg-muted"
                    >
                      <Binoculars size={14} />
                      My Sightings
                    </Link>
                    <Link
                      href="/profile"
                      onClick={() => setMobileOpen(false)}
                      className="flex items-center gap-2 px-3 py-2 text-sm rounded-md text-muted-foreground hover:text-foreground hover:bg-muted"
                    >
                      <UserIcon size={14} />
                      Profile
                    </Link>
                    <button
                      onClick={() => { setMobileOpen(false); handleLogout(); }}
                      className="flex items-center gap-2 px-3 py-2 text-sm rounded-md text-destructive hover:bg-destructive/10"
                    >
                      <LogOut size={14} />
                      Sign out
                    </button>
                  </>
                ) : (
                  <Link
                    href="/login"
                    onClick={() => setMobileOpen(false)}
                    className="flex items-center gap-2 px-3 py-2 text-sm rounded-md text-muted-foreground hover:text-foreground hover:bg-muted"
                  >
                    <UserIcon size={14} />
                    Sign in
                  </Link>
                )}
              </div>
            </SheetContent>
          </Sheet>
        </div>
      </div>
    </header>
  );
}
