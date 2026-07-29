"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { toast } from "sonner";
import { Loader2, Send, Radio } from "lucide-react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { formatDistanceToNow } from "date-fns";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { DataTable, type Column } from "@/components/shared/data-table";
import { Badge } from "@/components/ui/badge";
import type { ApiResponse, PaginationMeta } from "@/types";

const broadcastSchema = z.object({
  title: z.string().min(5, "Title must be at least 5 characters"),
  body: z.string().min(10, "Message must be at least 10 characters"),
  type: z.enum(["system", "event", "educational_alert"]),
});

type BroadcastForm = z.infer<typeof broadcastSchema>;

interface BroadcastItem {
  created_at: string;
  title: string;
  body: string;
  type: "system" | "event" | "educational_alert";
}

const TYPE_LABELS: Record<string, string> = {
  system: "📢 System",
  event: "📅 Event",
  educational_alert: "🦋 Educational",
};

const TYPE_STYLES: Record<string, string> = {
  system: "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-300",
  event: "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-300",
  educational_alert: "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-300",
};

export default function BroadcastPage() {
  const qc = useQueryClient();
  const [page, setPage] = useState(1);

  // Fetch past broadcasts list
  const { data, isLoading } = useQuery({
    queryKey: ["broadcast-history", page],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        per_page: "10",
      });
      const res = await api.get<ApiResponse<BroadcastItem[]>>(`/admin/cms/broadcast/history?${params}`);
      return { items: res.data.data, meta: res.data.meta as PaginationMeta };
    },
  });

  const {
    register,
    handleSubmit,
    setValue,
    watch,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<BroadcastForm>({
    resolver: zodResolver(broadcastSchema),
    defaultValues: { type: "system" },
  });

  const selectedType = watch("type");

  const mutation = useMutation({
    mutationFn: (payload: BroadcastForm) => api.post("/admin/cms/broadcast", payload),
    onSuccess: () => {
      toast.success("Broadcast alert sent to all active users successfully!");
      reset();
      qc.invalidateQueries({ queryKey: ["broadcast-history"] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const columns: Column<BroadcastItem>[] = [
    {
      key: "type",
      header: "Type",
      cell: (item) => (
        <Badge variant="secondary" className={TYPE_STYLES[item.type] ?? ""}>
          {TYPE_LABELS[item.type] ?? item.type}
        </Badge>
      ),
    },
    {
      key: "title",
      header: "Message Details",
      cell: (item) => (
        <div className="space-y-1">
          <p className="font-semibold text-xs text-foreground leading-snug">{item.title}</p>
          <p className="text-[11px] text-muted-foreground line-clamp-2 max-w-md leading-relaxed">{item.body}</p>
        </div>
      ),
    },
    {
      key: "created_at",
      header: "Sent At",
      cell: (item) => (
        <span className="text-[11px] text-muted-foreground whitespace-nowrap">
          {item.created_at ? formatDistanceToNow(new Date(item.created_at), { addSuffix: true }) : "—"}
        </span>
      ),
    },
  ];

  return (
    <div className="p-4 md:p-6 space-y-6">
      <div>
        <h2 className="text-base font-semibold flex items-center gap-2">
          <Radio size={18} className="text-primary animate-pulse" /> Broadcast Center
        </h2>
        <p className="text-xs text-muted-foreground">
          Manage system-wide broadcast communications and push notifications.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
        {/* History Table */}
        <div className="lg:col-span-2 space-y-4">
          <Card>
            <CardHeader className="py-4">
              <CardTitle className="text-xs font-semibold">Past Broadcasts History</CardTitle>
            </CardHeader>
            <CardContent className="p-0">
              <DataTable
                columns={columns}
                data={data?.items ?? []}
                loading={isLoading}
                meta={data?.meta}
                onPageChange={setPage}
                emptyMessage="No broadcasts sent yet."
              />
            </CardContent>
          </Card>
        </div>

        {/* Compose Form */}
        <div>
          <Card className="border-primary/20 shadow-md">
            <CardHeader className="py-4">
              <CardTitle className="text-xs font-semibold flex items-center gap-1.5">
                <Send size={13} className="text-primary" /> Send Global Broadcast
              </CardTitle>
              <CardDescription className="text-[10px]">
                Send an instant in-app alert and push notification to all active users.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4 pt-0">
              <form onSubmit={handleSubmit((d) => mutation.mutate(d))} className="space-y-4">
                
                {/* Alert Type */}
                <div className="space-y-1">
                  <Label htmlFor="type" className="text-[11px] font-medium">Alert Type</Label>
                  <Select
                    value={selectedType}
                    onValueChange={(v) => setValue("type", v as any, { shouldValidate: true })}
                  >
                    <SelectTrigger className="w-full text-xs h-8">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="system">📢 System Alert (Maintenance/Global)</SelectItem>
                      <SelectItem value="event">📅 Event Announcement (Gatherings/News)</SelectItem>
                      <SelectItem value="educational_alert">🦋 Educational Update (Species/Facts)</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                {/* Title */}
                <div className="space-y-1">
                  <Label htmlFor="title" className="text-[11px] font-medium">Notification Title *</Label>
                  <Input
                    id="title"
                    placeholder="e.g. Scheduled System Upgrades Tonight"
                    className="h-8 text-xs placeholder:text-muted-foreground/50"
                    {...register("title")}
                  />
                  {errors.title && (
                    <p className="text-[10px] text-destructive">{errors.title.message}</p>
                  )}
                </div>

                {/* Message Body */}
                <div className="space-y-1">
                  <Label htmlFor="body" className="text-[11px] font-medium">Message Body *</Label>
                  <Textarea
                    id="body"
                    rows={4}
                    placeholder="Describe the alert announcement in detail..."
                    className="text-xs placeholder:text-muted-foreground/50 min-h-[80px]"
                    {...register("body")}
                  />
                  {errors.body && (
                    <p className="text-[10px] text-destructive">{errors.body.message}</p>
                  )}
                </div>

                {/* Submit button */}
                <Button 
                  type="submit" 
                  disabled={isSubmitting || mutation.isPending} 
                  className="w-full h-8 text-xs mt-2"
                >
                  {(isSubmitting || mutation.isPending) && (
                    <Loader2 size={13} className="mr-1.5 animate-spin" />
                  )}
                  Dispatch Broadcast Alert
                </Button>
              </form>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
