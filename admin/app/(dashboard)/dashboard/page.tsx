"use client";

import { useQuery } from "@tanstack/react-query";
import { Users, Eye, Leaf, Cpu, Clock, TrendingUp, Flag } from "lucide-react";
import { formatDistanceToNow } from "date-fns";

import api from "@/lib/api";
import { StatsCard } from "@/components/dashboard/stats-card";
import { ObservationChart } from "@/components/dashboard/observation-chart";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import type { ApiResponse, DashboardStats, Observation } from "@/types";

function statusBadge(status: string) {
  const map: Record<string, string> = {
    pending: "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400",
    ai_identified: "bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400",
    expert_verified: "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400",
    community_verified: "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400",
    rejected: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400",
  };
  return map[status] ?? "bg-muted text-muted-foreground";
}

export default function DashboardPage() {
  const { data: statsData, isLoading: statsLoading } = useQuery({
    queryKey: ["dashboard-stats"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<DashboardStats>>("/admin/dashboard/stats");
      return res.data.data;
    },
  });

  const { data: recentObs, isLoading: obsLoading } = useQuery({
    queryKey: ["recent-observations"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<Observation[]>>(
        "/admin/observations/?per_page=8&sort=created_at&order=desc"
      );
      return res.data.data;
    },
  });

  const stats = statsData;

  return (
    <div className="p-4 md:p-6 space-y-6">
      {/* Stats grid */}
      <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-6 gap-3">
        <StatsCard
          title="Total Users"
          value={stats?.total_users}
          icon={Users}
          loading={statsLoading}
          accent="blue"
        />
        <StatsCard
          title="Observations"
          value={stats?.total_observations}
          icon={Eye}
          loading={statsLoading}
          accent="green"
        />
        <StatsCard
          title="Species"
          value={stats?.total_species}
          icon={Leaf}
          loading={statsLoading}
          accent="green"
        />
        <StatsCard
          title="Identifications"
          value={stats?.total_identifications}
          icon={Cpu}
          loading={statsLoading}
          accent="default"
        />
        <StatsCard
          title="Pending Review"
          value={stats?.pending_observations}
          icon={Clock}
          loading={statsLoading}
          accent="orange"
        />
        <StatsCard
          title="New This Month"
          value={stats?.new_observations_30d}
          icon={TrendingUp}
          loading={statsLoading}
          accent="blue"
          description="observations, last 30 days"
        />
        <StatsCard
          title="Flagged Users"
          value={stats?.flagged_users}
          icon={Flag}
          loading={statsLoading}
          accent="orange"
          description={
            stats?.warned_users ? `+ ${stats.warned_users} with warnings` : undefined
          }
        />
      </div>

      {/* Chart + Recent observations */}
      <div className="grid grid-cols-1 lg:grid-cols-5 gap-4">
        {/* Chart — 3/5 */}
        <div className="lg:col-span-3">
          <ObservationChart loading={statsLoading} />
        </div>

        {/* Recent observations — 2/5 */}
        <div className="lg:col-span-2">
          <Card className="h-full">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-semibold">Recent Observations</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 overflow-y-auto max-h-[240px]">
              {obsLoading
                ? Array.from({ length: 5 }).map((_, i) => (
                    <div key={i} className="flex items-center gap-2">
                      <Skeleton className="size-8 rounded-full shrink-0" />
                      <div className="space-y-1 flex-1">
                        <Skeleton className="h-3 w-3/4" />
                        <Skeleton className="h-3 w-1/2" />
                      </div>
                    </div>
                  ))
                : (recentObs ?? []).map((obs) => (
                    <div key={obs.id} className="flex items-start gap-2.5 py-1">
                      <div className="size-8 rounded-full bg-muted flex items-center justify-center text-sm shrink-0">
                        🦋
                      </div>
                      <div className="flex-1 min-w-0">
                        <p className="text-xs font-medium truncate">
                          {obs.title ?? obs.identified_species_name ?? "Unknown butterfly"}
                        </p>
                        <div className="flex items-center gap-1.5 mt-0.5">
                          <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-medium ${statusBadge(obs.verification_status)}`}>
                            {obs.verification_status.replace("_", " ")}
                          </span>
                          <span className="text-[10px] text-muted-foreground">
                            {formatDistanceToNow(new Date(obs.created_at), { addSuffix: true })}
                          </span>
                        </div>
                      </div>
                    </div>
                  ))}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
