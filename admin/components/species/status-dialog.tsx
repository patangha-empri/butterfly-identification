"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Eye, EyeOff, Loader2 } from "lucide-react";
import { toast } from "sonner";

import api, { apiErrorMessage } from "@/lib/api";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import type { Species } from "@/types";

/**
 * Confirmation for the only destructive-looking action on a species.
 *
 * It spells out the consequence in full because "deactivate" reads as "delete"
 * to most people: the record stays, observations keep working, and it can be
 * undone. Nothing here removes data.
 */
export function SpeciesStatusDialog({
  species,
  open,
  onOpenChange,
  onDone,
}: {
  species: Species | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onDone?: () => void;
}) {
  const qc = useQueryClient();
  const deactivating = species?.is_active !== false;

  const mutation = useMutation({
    mutationFn: async () => {
      if (!species) return;
      if (deactivating) {
        await api.delete(`/admin/species/${species.id}`);
      } else {
        await api.post(`/admin/species/${species.id}/activate`);
      }
    },
    onSuccess: () => {
      const id = species!.id;
      const isActive = !deactivating;

      // Patch the cache before refetching so the badge flips immediately.
      // Invalidation alone left the old value on screen for seconds — the admin
      // list counts observations for every row, so its refetch is not instant —
      // and that read as the toggle having done nothing. The invalidations below
      // still run, so the server stays the source of truth; this only covers the
      // gap. A row filtered out by the current status filter self-corrects when
      // the refetch lands.
      qc.setQueriesData<{ species: Species[] }>({ queryKey: ["species"] }, (old) =>
        old && Array.isArray(old.species)
          ? {
              ...old,
              species: old.species.map((s) =>
                s.id === id ? { ...s, is_active: isActive } : s
              ),
            }
          : old
      );
      qc.setQueriesData<Species>({ queryKey: ["species-detail"] }, (old) =>
        old && old.id === id ? { ...old, is_active: isActive } : old
      );

      toast.success(
        deactivating
          ? `“${species?.common_name}” is now hidden from the mobile app.`
          : `“${species?.common_name}” is visible in the mobile app again.`
      );
      qc.invalidateQueries({ queryKey: ["species"] });
      qc.invalidateQueries({ queryKey: ["species-detail"] });
      onOpenChange(false);
      onDone?.();
    },
    onError: (err) => toast.error(apiErrorMessage(err)),
  });

  if (!species) return null;

  const observations = species.observation_count ?? 0;

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle className="flex items-center gap-2">
            {deactivating ? <EyeOff size={17} /> : <Eye size={17} />}
            {deactivating ? "Hide" : "Show"} “{species.common_name}”{" "}
            {deactivating ? "from" : "in"} the mobile app?
          </AlertDialogTitle>
          <AlertDialogDescription asChild>
            <div className="space-y-3 text-sm">
              {deactivating ? (
                <>
                  <p>Setting this species to Inactive means:</p>
                  <ul className="list-disc space-y-1 pl-5 text-muted-foreground">
                    <li>
                      It stops appearing in the app&apos;s species list, search and
                      identification results.
                    </li>
                    <li>
                      Its {observations > 0 ? <strong>{observations}</strong> : "0"}{" "}
                      existing observation{observations === 1 ? "" : "s"}{" "}
                      {observations === 1 ? "stays" : "stay"} exactly as{" "}
                      {observations === 1 ? "it is" : "they are"} — nothing is
                      deleted or unlinked.
                    </li>
                    <li>
                      It stays here in the admin panel, and you can reverse this at
                      any time with <strong>Reactivate</strong>.
                    </li>
                  </ul>
                </>
              ) : (
                <p className="text-muted-foreground">
                  This species will appear again in the app&apos;s species list,
                  search and identification results, exactly as it did before.
                </p>
              )}
            </div>
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel disabled={mutation.isPending}>Cancel</AlertDialogCancel>
          <AlertDialogAction
            onClick={(e) => {
              e.preventDefault();
              mutation.mutate();
            }}
            disabled={mutation.isPending}
            className={deactivating ? "bg-amber-600 hover:bg-amber-700" : ""}
          >
            {mutation.isPending && <Loader2 className="mr-2 size-4 animate-spin" />}
            {deactivating ? "Set to Inactive" : "Reactivate"}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  );
}
