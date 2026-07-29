"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { toast } from "sonner";
import { Loader2, Eye, Award, TrendingUp, CalendarDays } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import { Separator } from "@/components/ui/separator";
import api, { apiErrorMessage } from "@/lib/api";
import { getCurrentUser, setCurrentUser } from "@/lib/auth";
import type { ApiResponse, User } from "@/types";

const schema = z.object({
  full_name: z.string().min(2, "Name must be at least 2 characters"),
  bio: z.string().max(500).optional(),
});
type FormData = z.infer<typeof schema>;

export default function ProfilePage() {
  const router = useRouter();
  const qc = useQueryClient();

  const { data: user, isLoading } = useQuery({
    queryKey: ["me"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<User>>("/users/me");
      return res.data.data;
    },
  });

  const { register, handleSubmit, reset, formState: { errors, isSubmitting, isDirty } } =
    useForm<FormData>({ resolver: zodResolver(schema) });

  useEffect(() => {
    if (user) reset({ full_name: user.full_name, bio: user.bio ?? "" });
  }, [user, reset]);

  const saveMutation = useMutation({
    mutationFn: async (data: FormData) => {
      const res = await api.patch<ApiResponse<User>>("/users/me", data);
      return res.data.data;
    },
    onSuccess: (updated) => {
      setCurrentUser(updated);
      qc.setQueryData(["me"], updated);
      toast.success("Profile updated.");
      reset({ full_name: updated.full_name, bio: updated.bio ?? "" });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  const initials = user?.full_name?.split(" ").map((n) => n[0]).slice(0, 2).join("").toUpperCase() ?? "U";

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8 max-w-2xl space-y-6">
        <Skeleton className="h-8 w-32" />
        <div className="flex items-center gap-4">
          <Skeleton className="size-16 rounded-full" />
          <div className="space-y-2"><Skeleton className="h-5 w-32" /><Skeleton className="h-4 w-24" /></div>
        </div>
        <Skeleton className="h-48 rounded-lg" />
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8 max-w-2xl space-y-6">
      <h1 className="text-2xl font-bold">Profile</h1>

      {/* Avatar + stats */}
      <Card>
        <CardContent className="pt-6 space-y-4">
          <div className="flex items-center gap-4">
            <Avatar className="size-16">
              <AvatarImage src={user?.profile_image_url ?? undefined} />
              <AvatarFallback className="text-lg">{initials}</AvatarFallback>
            </Avatar>
            <div>
              <p className="font-semibold text-lg">{user?.full_name}</p>
              <p className="text-sm text-muted-foreground">@{user?.username}</p>
              <p className="text-xs text-muted-foreground capitalize">{user?.role ?? "user"}</p>
            </div>
          </div>

          {user?.stats && (
            <>
              <Separator />
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 text-center">
                {[
                  { icon: Eye, label: "Sightings", value: user.stats.total_observations },
                  { icon: Award, label: "Verified", value: user.stats.verified_observations },
                  { icon: TrendingUp, label: "Streak", value: `${user.stats.observation_streak}d` },
                  { icon: CalendarDays, label: "Best Streak", value: `${user.stats.longest_streak}d` },
                ].map(({ icon: Icon, label, value }) => (
                  <div key={label} className="space-y-1">
                    <Icon size={16} className="mx-auto text-muted-foreground" />
                    <p className="font-bold text-lg">{value}</p>
                    <p className="text-xs text-muted-foreground">{label}</p>
                  </div>
                ))}
              </div>
            </>
          )}
        </CardContent>
      </Card>

      {/* Edit form */}
      <Card>
        <CardHeader className="pb-3">
          <CardTitle className="text-sm">Edit Profile</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit((d) => saveMutation.mutate(d))} className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="full_name">Full Name</Label>
              <Input id="full_name" {...register("full_name")} aria-invalid={!!errors.full_name} />
              {errors.full_name && <p className="text-xs text-destructive">{errors.full_name.message}</p>}
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="bio">Bio <span className="text-muted-foreground text-xs">(optional)</span></Label>
              <Textarea id="bio" rows={3} placeholder="Tell the community about your interest in butterflies…"
                {...register("bio")} />
              {errors.bio && <p className="text-xs text-destructive">{errors.bio.message}</p>}
            </div>
            <div className="space-y-1.5">
              <Label>Email</Label>
              <Input value={user?.email ?? ""} disabled className="bg-muted" />
              <p className="text-xs text-muted-foreground">Email cannot be changed here.</p>
            </div>
            <Button type="submit" disabled={!isDirty || isSubmitting || saveMutation.isPending}>
              {(isSubmitting || saveMutation.isPending) && <Loader2 className="mr-2 size-4 animate-spin" />}
              Save Changes
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
