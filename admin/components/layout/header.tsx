"use client";

import { useEffect, useState } from "react";
import { useRouter, usePathname } from "next/navigation";
import Link from "next/link";
import { Menu, LogOut, User as UserIcon } from "lucide-react";
import { toast } from "sonner";

import { getCurrentUser, clearAuth } from "@/lib/auth";
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
  const segment = pathname.split("/")[1] ?? "";
  return PAGE_TITLES[segment] ?? "Dashboard";
}

export function Header() {
  const router = useRouter();
  const pathname = usePathname();
  const [user, setUser] = useState<User | null>(null);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    setUser(getCurrentUser());
  }, [pathname]);

  function handleLogout() {
    clearAuth();
    toast.success("Signed out successfully.");
    router.push("/login");
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
            <Link href="/profile" className="gap-2">
              <UserIcon size={14} />
              Profile
            </Link>
          </DropdownMenuItem>
          <DropdownMenuSeparator />
          <DropdownMenuItem
            onClick={handleLogout}
            className="gap-2 text-destructive focus:text-destructive"
          >
            <LogOut size={14} />
            Sign out
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </header>
  );
}
