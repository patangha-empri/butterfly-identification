import type { VerificationStatus } from "@/types";

const STATUS_CONFIG: Record<
  VerificationStatus,
  { label: string; className: string }
> = {
  pending: {
    label: "Pending",
    className: "bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400",
  },
  ai_identified: {
    label: "AI Identified",
    className: "bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400",
  },
  expert_verified: {
    label: "Expert Verified",
    className: "bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400",
  },
  community_verified: {
    label: "Community Verified",
    className: "bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-400",
  },
  rejected: {
    label: "Rejected",
    className: "bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400",
  },
};

export function StatusBadge({ status }: { status: VerificationStatus }) {
  const cfg = STATUS_CONFIG[status] ?? STATUS_CONFIG.pending;
  return (
    <span
      className={`inline-flex items-center text-[10px] font-medium px-2 py-0.5 rounded-full ${cfg.className}`}
    >
      {cfg.label}
    </span>
  );
}
