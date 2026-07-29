"use client";

import { useRef, useState } from "react";
import { UploadCloud, X, ImageIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface ImageUploadProps {
  value: File[];
  onChange: (files: File[]) => void;
  maxFiles?: number;
  className?: string;
}

export function ImageUpload({
  value,
  onChange,
  maxFiles = 5,
  className,
}: ImageUploadProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [dragging, setDragging] = useState(false);

  const previews = value.map((f) => URL.createObjectURL(f));

  function addFiles(incoming: FileList | null) {
    if (!incoming) return;
    const newFiles = Array.from(incoming).filter((f) => f.type.startsWith("image/"));
    const merged = [...value, ...newFiles].slice(0, maxFiles);
    onChange(merged);
  }

  function removeFile(idx: number) {
    onChange(value.filter((_, i) => i !== idx));
  }

  return (
    <div className={cn("space-y-3", className)}>
      {/* Drop zone */}
      <div
        onClick={() => inputRef.current?.click()}
        onDragOver={(e) => { e.preventDefault(); setDragging(true); }}
        onDragLeave={() => setDragging(false)}
        onDrop={(e) => {
          e.preventDefault();
          setDragging(false);
          addFiles(e.dataTransfer.files);
        }}
        className={cn(
          "border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition-colors",
          dragging
            ? "border-primary bg-primary/5"
            : "border-muted-foreground/25 hover:border-muted-foreground/50 hover:bg-muted/30"
        )}
      >
        <UploadCloud className="mx-auto size-8 text-muted-foreground mb-2" />
        <p className="text-sm font-medium">Drop images here or click to browse</p>
        <p className="text-xs text-muted-foreground mt-1">
          Up to {maxFiles} images • JPG, PNG, WEBP
        </p>
        <input
          ref={inputRef}
          type="file"
          accept="image/*"
          multiple
          className="hidden"
          onChange={(e) => addFiles(e.target.files)}
        />
      </div>

      {/* Preview grid */}
      {previews.length > 0 && (
        <div className="grid grid-cols-3 sm:grid-cols-5 gap-2">
          {previews.map((src, idx) => (
            <div key={idx} className="relative aspect-square rounded-md overflow-hidden bg-muted group">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={src} alt="" className="w-full h-full object-cover" />
              <Button
                type="button"
                variant="destructive"
                size="icon"
                className="absolute top-1 right-1 size-5 opacity-0 group-hover:opacity-100 transition-opacity"
                onClick={(e) => { e.stopPropagation(); removeFile(idx); }}
              >
                <X size={10} />
              </Button>
              {idx === 0 && (
                <div className="absolute bottom-0 left-0 right-0 bg-primary/80 text-primary-foreground text-[9px] text-center py-0.5">
                  Primary
                </div>
              )}
            </div>
          ))}
          {/* Empty slot */}
          {value.length < maxFiles && (
            <button
              type="button"
              onClick={() => inputRef.current?.click()}
              className="aspect-square rounded-md border-2 border-dashed border-muted-foreground/25 flex items-center justify-center hover:border-muted-foreground/50 transition-colors"
            >
              <ImageIcon size={18} className="text-muted-foreground/50" />
            </button>
          )}
        </div>
      )}
    </div>
  );
}
