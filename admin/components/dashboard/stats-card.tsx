import { type LucideIcon } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { cn } from "@/lib/utils";

interface StatsCardProps {
  title: string;
  value: number | string | undefined;
  icon: LucideIcon;
  description?: string;
  loading?: boolean;
  accent?: "default" | "green" | "blue" | "orange" | "red";
}

const accentClasses: Record<string, string> = {
  default: "bg-primary/10 text-primary",
  green: "bg-emerald-500/10 text-emerald-600 dark:text-emerald-400",
  blue: "bg-blue-500/10 text-blue-600 dark:text-blue-400",
  orange: "bg-orange-500/10 text-orange-600 dark:text-orange-400",
  red: "bg-red-500/10 text-red-600 dark:text-red-400",
};

export function StatsCard({
  title,
  value,
  icon: Icon,
  description,
  loading,
  accent = "default",
}: StatsCardProps) {
  return (
    <Card>
      <CardContent className="flex items-center gap-4 pt-5 pb-5">
        <div className={cn("rounded-xl p-2.5 shrink-0", accentClasses[accent])}>
          <Icon size={20} />
        </div>
        <div className="min-w-0">
          <p className="text-xs text-muted-foreground font-medium truncate">{title}</p>
          {loading ? (
            <Skeleton className="h-6 w-16 mt-1" />
          ) : (
            <p className="text-2xl font-bold leading-none mt-0.5">
              {value?.toLocaleString() ?? "—"}
            </p>
          )}
          {description && (
            <p className="text-xs text-muted-foreground mt-0.5">{description}</p>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
