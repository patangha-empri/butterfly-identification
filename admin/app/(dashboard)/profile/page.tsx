"use client";

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { toast } from "sonner";
import { Loader2 } from "lucide-react";

import api, { apiErrorMessage } from "@/lib/api";
import { setCurrentUser } from "@/lib/auth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import type { ApiResponse, User } from "@/types";

// Matches the backend UpdateProfileSchema (PUT /users/me).
const profileSchema = z.object({
  full_name: z.string().min(2, "Required"),
  username: z
    .string()
    .min(3, "At least 3 characters")
    .regex(/^[a-zA-Z0-9_]+$/, "Letters, numbers, and underscores only"),
  bio: z.string().max(500, "Max 500 characters").optional(),
});

type ProfileForm = z.infer<typeof profileSchema>;

export default function ProfilePage() {
  const qc = useQueryClient();

  const { data: user, isLoading } = useQuery({
    queryKey: ["me"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<User>>("/users/me");
      return res.data.data;
    },
  });

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<ProfileForm>({
    resolver: zodResolver(profileSchema),
    values: user
      ? {
          full_name: user.full_name,
          username: user.username,
          bio: user.bio ?? "",
        }
      : undefined,
  });

  const mutation = useMutation({
    mutationFn: (data: ProfileForm) =>
      api.put<ApiResponse<User>>("/users/me", data),
    onSuccess: (res) => {
      toast.success("Profile updated.");
      // Keep the header/avatar in sync with the edited profile.
      if (res.data.data) setCurrentUser(res.data.data);
      qc.invalidateQueries({ queryKey: ["me"] });
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  if (isLoading) {
    return (
      <div className="p-4 md:p-6 space-y-4 max-w-2xl">
        <Skeleton className="h-8 w-32" />
        <Skeleton className="h-64" />
      </div>
    );
  }

  if (!user) {
    return <div className="p-6 text-muted-foreground">Could not load your profile.</div>;
  }

  return (
    <div className="p-4 md:p-6 space-y-4 max-w-2xl">
      <div className="flex items-center gap-3">
        <Avatar className="size-14">
          <AvatarImage src={user.profile_image_url} alt={user.full_name} />
          <AvatarFallback className="text-lg">
            {user.full_name?.slice(0, 2).toUpperCase()}
          </AvatarFallback>
        </Avatar>
        <div>
          <div className="flex items-center gap-2">
            <h2 className="text-base font-semibold">{user.full_name}</h2>
            <Badge variant="secondary" className="capitalize">
              {user.role ?? "user"}
            </Badge>
          </div>
          <p className="text-xs text-muted-foreground">{user.email}</p>
        </div>
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-sm">Edit Profile</CardTitle>
        </CardHeader>
        <CardContent>
          <form
            onSubmit={handleSubmit((d) => mutation.mutate(d))}
            className="space-y-4"
          >
            <div className="space-y-1.5">
              <Label htmlFor="full_name">Full Name</Label>
              <Input id="full_name" {...register("full_name")} aria-invalid={!!errors.full_name} />
              {errors.full_name && (
                <p className="text-xs text-destructive">{errors.full_name.message}</p>
              )}
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="username">Username</Label>
              <Input id="username" {...register("username")} aria-invalid={!!errors.username} />
              {errors.username && (
                <p className="text-xs text-destructive">{errors.username.message}</p>
              )}
            </div>

            <div className="space-y-1.5">
              <Label htmlFor="bio">Bio</Label>
              <Textarea id="bio" rows={3} {...register("bio")} aria-invalid={!!errors.bio} />
              {errors.bio && <p className="text-xs text-destructive">{errors.bio.message}</p>}
            </div>

            <div className="pt-2">
              <Button type="submit" disabled={isSubmitting || mutation.isPending} size="sm">
                {(isSubmitting || mutation.isPending) && (
                  <Loader2 size={13} className="mr-1.5 animate-spin" />
                )}
                Save Changes
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
