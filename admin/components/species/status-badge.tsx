"use client";

import { Eye, EyeOff } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";

/**
 * Active / Inactive badge with the explanation attached.
 *
 * "Inactive" is not obvious on its own — an admin needs to know it controls
 * mobile-app visibility and that nothing is deleted. Rather than document that
 * once in a corner, the meaning travels with the badge everywhere it appears.
 */
export function SpeciesStatusBadge({
  isActive,
  className,
}: {
  isActive: boolean | undefined;
  className?: string;
}) {
  const active = isActive !== false;

  return (
    <Tooltip>
      <TooltipTrigger asChild>
        <Badge
          variant={active ? "secondary" : "outline"}
          className={`gap-1 cursor-help ${
            active
              ? "bg-green-100 text-green-800 hover:bg-green-100"
              : "border-amber-300 bg-amber-50 text-amber-800"
          } ${className ?? ""}`}
        >
          {active ? <Eye size={11} /> : <EyeOff size={11} />}
          {active ? "Active" : "Inactive"}
        </Badge>
      </TooltipTrigger>
      <TooltipContent className="max-w-xs">
        {active ? (
          <p>
            Visible in the mobile app — appears in species search, browsing and
            identification results.
          </p>
        ) : (
          <p>
            Hidden from the mobile app. Nothing is deleted: the record and all
            existing observations are kept, and you can make it visible again at
            any time with Reactivate.
          </p>
        )}
      </TooltipContent>
    </Tooltip>
  );
}
