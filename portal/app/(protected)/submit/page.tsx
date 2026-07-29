"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useQuery, useMutation } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { toast } from "sonner";
import { MapPin, Loader2, CheckCircle2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ImageUpload } from "@/components/shared/image-upload";
import api, { apiErrorMessage } from "@/lib/api";
import type { ApiResponse, State, Observation } from "@/types";

const schema = z.object({
  title: z.string().optional(),
  notes: z.string().optional(),
  state_id: z.string().min(1, "Please select a state"),
  latitude: z.string().optional(),
  longitude: z.string().optional(),
  location_name: z.string().optional(),
  observed_at: z.string().optional(),
  privacy: z.enum(["public", "private", "anonymous"]),
});
type FormData = z.infer<typeof schema>;

export default function SubmitPage() {
  const router = useRouter();
  const [images, setImages] = useState<File[]>([]);
  const [step, setStep] = useState<"form" | "success">("form");
  const [createdId, setCreatedId] = useState<string | null>(null);

  const { data: states } = useQuery({
    queryKey: ["states"],
    queryFn: async () => {
      const res = await api.get<ApiResponse<State[]>>("/geography/states");
      return res.data.data;
    },
  });

  const { register, handleSubmit, setValue, watch, formState: { errors } } =
    useForm<FormData>({
      resolver: zodResolver(schema),
      defaultValues: { privacy: "public", state_id: "" },
    });

  const mutation = useMutation({
    mutationFn: async (data: FormData) => {
      // 1. Create observation
      const payload = {
        ...data,
        state_id: parseInt(data.state_id),
        latitude: data.latitude ? parseFloat(data.latitude) : undefined,
        longitude: data.longitude ? parseFloat(data.longitude) : undefined,
      };
      const res = await api.post<ApiResponse<Observation>>("/observations", payload);
      const obs = res.data.data;

      // 2. Upload images if provided
      if (images.length > 0) {
        const form = new FormData();
        images.forEach((f, i) => {
          form.append("images", f);
          if (i === 0) form.append("primary_index", "0");
        });
        await api.post(`/observations/${obs.id}/images`, form, {
          headers: { "Content-Type": "multipart/form-data" },
        });
      }

      return obs;
    },
    onSuccess: (obs) => {
      setCreatedId(obs.id);
      setStep("success");
      toast.success("Sighting submitted! AI identification is running…");
    },
    onError: (err) => {
      toast.error(apiErrorMessage(err));
    },
  });

  function useCurrentLocation() {
    if (!navigator.geolocation) {
      toast.error("Geolocation not supported by your browser.");
      return;
    }
    navigator.geolocation.getCurrentPosition(
      (pos) => {
        setValue("latitude", pos.coords.latitude.toFixed(6));
        setValue("longitude", pos.coords.longitude.toFixed(6));
        toast.success("Location detected!");
      },
      () => toast.error("Could not detect location. Please enter manually.")
    );
  }

  if (step === "success") {
    return (
      <div className="container mx-auto px-4 py-16 max-w-md text-center space-y-6">
        <div className="flex justify-center">
          <CheckCircle2 className="size-16 text-green-500" />
        </div>
        <div className="space-y-2">
          <h1 className="text-2xl font-bold">Sighting Submitted!</h1>
          <p className="text-muted-foreground">
            Your observation has been uploaded. Our AI is analysing the image to identify the species.
            Check back in a few moments.
          </p>
        </div>
        <div className="flex flex-col gap-2">
          {createdId && (
            <Button asChild>
              <a href={`/sightings/${createdId}`}>View Sighting</a>
            </Button>
          )}
          <Button variant="outline" onClick={() => { setStep("form"); setImages([]); }}>
            Submit Another
          </Button>
          <Button variant="ghost" asChild>
            <a href="/my-sightings">My Sightings</a>
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8 max-w-2xl space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Submit a Sighting</h1>
        <p className="text-sm text-muted-foreground">
          Upload photos of a butterfly you spotted and our AI will help identify it.
        </p>
      </div>

      <form onSubmit={handleSubmit((d) => mutation.mutate(d))} className="space-y-6">
        {/* Images */}
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-sm">Photos <span className="text-muted-foreground font-normal">(optional but recommended)</span></CardTitle>
          </CardHeader>
          <CardContent>
            <ImageUpload value={images} onChange={setImages} maxFiles={5} />
          </CardContent>
        </Card>

        {/* Basic details */}
        <Card>
          <CardHeader className="pb-3"><CardTitle className="text-sm">Details</CardTitle></CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-1.5">
              <Label htmlFor="title">Title <span className="text-muted-foreground text-xs">(optional)</span></Label>
              <Input id="title" placeholder="e.g. Crimson Rose near Munnar" {...register("title")} />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="notes">Notes <span className="text-muted-foreground text-xs">(optional)</span></Label>
              <Textarea id="notes" placeholder="Describe behaviour, wing condition, flowers it was feeding on…"
                rows={3} {...register("notes")} />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-1.5">
                <Label htmlFor="state_id">State *</Label>
                <Select onValueChange={(v) => setValue("state_id", v)}>
                  <SelectTrigger id="state_id" aria-invalid={!!errors.state_id}>
                    <SelectValue placeholder="Select state" />
                  </SelectTrigger>
                  <SelectContent>
                    {(states ?? []).map((s) => (
                      <SelectItem key={s.id} value={String(s.id)}>{s.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {errors.state_id && <p className="text-xs text-destructive">{errors.state_id.message}</p>}
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="observed_at">Date Observed <span className="text-muted-foreground text-xs">(optional)</span></Label>
                <Input id="observed_at" type="date" {...register("observed_at")} />
              </div>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="location_name">Location Name <span className="text-muted-foreground text-xs">(optional)</span></Label>
              <Input id="location_name" placeholder="e.g. Bandipur Forest, Karnataka" {...register("location_name")} />
            </div>
          </CardContent>
        </Card>

        {/* Location */}
        <Card>
          <CardHeader className="pb-3"><CardTitle className="text-sm">GPS Coordinates <span className="text-muted-foreground font-normal text-xs">(optional)</span></CardTitle></CardHeader>
          <CardContent className="space-y-3">
            <Button type="button" variant="outline" size="sm" onClick={useCurrentLocation} className="gap-2">
              <MapPin size={14} /> Use my current location
            </Button>
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1.5">
                <Label htmlFor="latitude">Latitude</Label>
                <Input id="latitude" placeholder="e.g. 11.4916" {...register("latitude")} />
              </div>
              <div className="space-y-1.5">
                <Label htmlFor="longitude">Longitude</Label>
                <Input id="longitude" placeholder="e.g. 76.4677" {...register("longitude")} />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Privacy */}
        <Card>
          <CardHeader className="pb-3"><CardTitle className="text-sm">Privacy</CardTitle></CardHeader>
          <CardContent>
            <Select value={watch("privacy")} onValueChange={(v) => setValue("privacy", v as "public" | "private" | "anonymous")}>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="public">Public — visible to everyone</SelectItem>
                <SelectItem value="anonymous">Anonymous — visible without your name</SelectItem>
                <SelectItem value="private">Private — only visible to you and admins</SelectItem>
              </SelectContent>
            </Select>
          </CardContent>
        </Card>

        <Button type="submit" className="w-full" size="lg" disabled={mutation.isPending}>
          {mutation.isPending && <Loader2 className="mr-2 size-4 animate-spin" />}
          {mutation.isPending ? "Submitting…" : "Submit Sighting"}
        </Button>
      </form>
    </div>
  );
}
