"use client";

import { useState } from "react";
import { toast } from "sonner";
import {
  Eye,
  Users,
  Leaf,
  Calendar,
  FileText,
  FileSpreadsheet,
  Download,
  Loader2,
  ChevronRight,
} from "lucide-react";

import api, { apiErrorMessage } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";

type ReportType = "observations" | "users" | "species";
type ReportFormat = "pdf" | "excel";
type DatePreset = "all" | "7days" | "30days" | "thismonth" | "custom";

export default function ReportsPage() {
  const [reportType, setReportType] = useState<ReportType>("observations");
  const [format, setFormat] = useState<ReportFormat>("pdf");
  const [preset, setPreset] = useState<DatePreset>("all");
  const [customFrom, setCustomFrom] = useState("");
  const [customTo, setCustomTo] = useState("");
  const [downloading, setDownloading] = useState(false);

  const getDatesForPreset = (preset: DatePreset) => {
    const today = new Date();
    let from = "";
    let to = today.toISOString().split("T")[0];

    if (preset === "7days") {
      const d = new Date();
      d.setDate(today.getDate() - 7);
      from = d.toISOString().split("T")[0];
    } else if (preset === "30days") {
      const d = new Date();
      d.setDate(today.getDate() - 30);
      from = d.toISOString().split("T")[0];
    } else if (preset === "thismonth") {
      const d = new Date(today.getFullYear(), today.getMonth(), 1);
      from = d.toISOString().split("T")[0];
    }
    return { from, to };
  };

  async function handleDownload() {
    setDownloading(true);
    try {
      let path = `/admin/reports/${reportType}/${format}`;
      const { from, to } =
        preset === "custom"
          ? { from: customFrom, to: customTo }
          : getDatesForPreset(preset);

      const params = [];
      if (from) params.push(`from_date=${from}`);
      if (to) params.push(`to_date=${to}`);
      if (params.length > 0) {
        path += `?${params.join("&")}`;
      }

      const res = await api.get(path, { responseType: "blob" });
      const disposition = res.headers["content-disposition"] as string | undefined;
      const match = disposition?.match(/filename="?([^"]+)"?/);
      const fallbackExt = format === "excel" ? "xlsx" : "pdf";
      const dateStr = new Date().toISOString().split("T")[0].replace(/-/g, "");
      const filename = match?.[1] ?? `${reportType}_report_${dateStr}.${fallbackExt}`;

      const url = window.URL.createObjectURL(res.data as Blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      a.remove();
      window.URL.revokeObjectURL(url);
      toast.success("Report downloaded successfully.");
    } catch (err) {
      toast.error(apiErrorMessage(err));
    } finally {
      setDownloading(false);
    }
  }

  return (
    <div className="max-w-4xl mx-auto p-4 md:p-8 space-y-6">
      <div className="space-y-1">
        <h2 className="text-2xl font-bold tracking-tight text-foreground flex items-center gap-2">
          Reports &amp; Exports Center
        </h2>
        <p className="text-sm text-muted-foreground">
          Generate, filter, and export administrative data reports from the platform.
        </p>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        {/* Dataset Selection */}
        <div className="md:col-span-2 space-y-6">
          <Card className="border-border shadow-sm bg-card/60 backdrop-blur-md">
            <CardHeader className="pb-4">
              <CardTitle className="text-base font-semibold flex items-center gap-2">
                <span className="flex items-center justify-center w-5 h-5 rounded-full bg-primary/10 text-primary text-xs font-bold">
                  1
                </span>
                Select Dataset
              </CardTitle>
              <CardDescription>
                Choose the resource category you want to export.
              </CardDescription>
            </CardHeader>
            <CardContent className="grid gap-3 sm:grid-cols-3">
              {/* Observations */}
              <div
                onClick={() => setReportType("observations")}
                className={`flex flex-col items-center justify-center p-4 rounded-xl border-2 transition-all duration-200 hover:scale-[1.02] hover:shadow-sm cursor-pointer ${
                  reportType === "observations"
                    ? "border-primary bg-primary/[0.03] text-primary shadow-sm shadow-primary/10"
                    : "border-border hover:border-muted-foreground/30 text-foreground"
                }`}
              >
                <div className={`p-2.5 rounded-lg mb-3 ${reportType === "observations" ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>
                  <Eye size={20} />
                </div>
                <span className="text-sm font-semibold mb-1">Observations</span>
                <span className="text-[11px] text-muted-foreground text-center">
                  Observer, location, and species validation logs.
                </span>
              </div>

              {/* Users */}
              <div
                onClick={() => setReportType("users")}
                className={`flex flex-col items-center justify-center p-4 rounded-xl border-2 transition-all duration-200 hover:scale-[1.02] hover:shadow-sm cursor-pointer ${
                  reportType === "users"
                    ? "border-primary bg-primary/[0.03] text-primary shadow-sm shadow-primary/10"
                    : "border-border hover:border-muted-foreground/30 text-foreground"
                }`}
              >
                <div className={`p-2.5 rounded-lg mb-3 ${reportType === "users" ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>
                  <Users size={20} />
                </div>
                <span className="text-sm font-semibold mb-1">Users</span>
                <span className="text-[11px] text-muted-foreground text-center">
                  User roster, permissions, and status history.
                </span>
              </div>

              {/* Species */}
              <div
                onClick={() => setReportType("species")}
                className={`flex flex-col items-center justify-center p-4 rounded-xl border-2 transition-all duration-200 hover:scale-[1.02] hover:shadow-sm cursor-pointer ${
                  reportType === "species"
                    ? "border-primary bg-primary/[0.03] text-primary shadow-sm shadow-primary/10"
                    : "border-border hover:border-muted-foreground/30 text-foreground"
                }`}
              >
                <div className={`p-2.5 rounded-lg mb-3 ${reportType === "species" ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>
                  <Leaf size={20} />
                </div>
                <span className="text-sm font-semibold mb-1">Species</span>
                <span className="text-[11px] text-muted-foreground text-center">
                  Complete scientific catalog and metrics.
                </span>
              </div>
            </CardContent>
          </Card>

          {/* Date Filtering */}
          <Card className="border-border shadow-sm bg-card/60 backdrop-blur-md">
            <CardHeader className="pb-4">
              <CardTitle className="text-base font-semibold flex items-center gap-2">
                <span className="flex items-center justify-center w-5 h-5 rounded-full bg-primary/10 text-primary text-xs font-bold">
                  2
                </span>
                Filter by Date Range
              </CardTitle>
              <CardDescription>
                Restrict the dataset to records created within a specific timeframe.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex flex-wrap gap-2">
                {(
                  [
                    { key: "all", label: "All Time" },
                    { key: "7days", label: "Last 7 Days" },
                    { key: "30days", label: "Last 30 Days" },
                    { key: "thismonth", label: "This Month" },
                    { key: "custom", label: "Custom Range" },
                  ] as const
                ).map((p) => (
                  <Button
                    key={p.key}
                    type="button"
                    size="sm"
                    variant={preset === p.key ? "default" : "outline"}
                    className="rounded-full text-xs"
                    onClick={() => setPreset(p.key)}
                  >
                    {p.label}
                  </Button>
                ))}
              </div>

              {preset === "custom" && (
                <div className="grid gap-4 sm:grid-cols-2 p-3.5 bg-muted/40 rounded-lg border border-border/60 animate-in fade-in slide-in-from-top-1 duration-200">
                  <div className="space-y-1.5">
                    <Label htmlFor="from-date" className="text-xs font-semibold">
                      Start Date
                    </Label>
                    <Input
                      id="from-date"
                      type="date"
                      value={customFrom}
                      onChange={(e) => setCustomFrom(e.target.value)}
                      className="h-9 bg-background"
                    />
                  </div>
                  <div className="space-y-1.5">
                    <Label htmlFor="to-date" className="text-xs font-semibold">
                      End Date
                    </Label>
                    <Input
                      id="to-date"
                      type="date"
                      value={customTo}
                      onChange={(e) => setCustomTo(e.target.value)}
                      className="h-9 bg-background"
                    />
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        </div>

        {/* Sidebar Settings & Download */}
        <div className="space-y-6">
          {/* Format Selection */}
          <Card className="border-border shadow-sm bg-card/60 backdrop-blur-md">
            <CardHeader className="pb-4">
              <CardTitle className="text-base font-semibold flex items-center gap-2">
                <span className="flex items-center justify-center w-5 h-5 rounded-full bg-primary/10 text-primary text-xs font-bold">
                  3
                </span>
                Choose Format
              </CardTitle>
            </CardHeader>
            <CardContent className="grid gap-3">
              {/* PDF Document */}
              <div
                onClick={() => setFormat("pdf")}
                className={`flex items-center gap-3 p-3 rounded-lg border-2 cursor-pointer transition-all duration-150 ${
                  format === "pdf"
                    ? "border-primary bg-primary/[0.03] text-primary"
                    : "border-border hover:border-muted-foreground/30 text-foreground"
                }`}
              >
                <div className={`p-1.5 rounded ${format === "pdf" ? "bg-primary/20" : "bg-muted"}`}>
                  <FileText size={16} />
                </div>
                <div className="flex flex-col text-left">
                  <span className="text-xs font-semibold">PDF Document</span>
                  <span className="text-[10px] text-muted-foreground">Best for sharing & printing.</span>
                </div>
              </div>

              {/* Excel Spreadsheet */}
              <div
                onClick={() => setFormat("excel")}
                className={`flex items-center gap-3 p-3 rounded-lg border-2 cursor-pointer transition-all duration-150 ${
                  format === "excel"
                    ? "border-primary bg-primary/[0.03] text-primary"
                    : "border-border hover:border-muted-foreground/30 text-foreground"
                }`}
              >
                <div className={`p-1.5 rounded ${format === "excel" ? "bg-primary/20" : "bg-muted"}`}>
                  <FileSpreadsheet size={16} />
                </div>
                <div className="flex flex-col text-left">
                  <span className="text-xs font-semibold">Excel Spreadsheet</span>
                  <span className="text-[10px] text-muted-foreground">Best for data analysis & raw access.</span>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Action Trigger Card */}
          <Card className="border-primary/20 shadow-md bg-gradient-to-br from-primary/[0.02] to-primary/[0.08]">
            <CardContent className="pt-6 space-y-4">
              <div className="space-y-1.5">
                <span className="text-[10px] font-bold tracking-widest text-primary uppercase block">
                  Ready to Export
                </span>
                <h4 className="text-sm font-semibold capitalize flex items-center gap-1.5 text-foreground">
                  {reportType} Report
                  <ChevronRight size={12} className="text-muted-foreground" />
                  <span className="uppercase text-xs font-bold text-muted-foreground">
                    {format}
                  </span>
                </h4>
                <p className="text-[11px] text-muted-foreground leading-normal">
                  You are exporting the selected category formatted according to your filters. Clicking download will request a background query.
                </p>
              </div>

              <Button
                onClick={handleDownload}
                disabled={downloading}
                className="w-full font-semibold shadow-sm transition-all duration-200"
              >
                {downloading ? (
                  <>
                    <Loader2 size={15} className="mr-2 animate-spin" />
                    Generating Report...
                  </>
                ) : (
                  <>
                    <Download size={15} className="mr-2" />
                    Download Export
                  </>
                )}
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
