"use client";

import { useEffect, useState } from "react";
import { Search, X } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  debounce?: number;
}

export function SearchInput({
  value,
  onChange,
  placeholder = "Search…",
  className,
  debounce = 400,
}: SearchInputProps) {
  const [local, setLocal] = useState(value);

  useEffect(() => {
    if (local === value) return;
    const t = setTimeout(() => onChange(local), debounce);
    return () => clearTimeout(t);
  }, [local, debounce, onChange, value]);

  useEffect(() => {
    setLocal(value);
  }, [value]);

  return (
    <div className={cn("relative", className)}>
      <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 text-muted-foreground size-3.5" />
      <Input
        value={local}
        onChange={(e) => setLocal(e.target.value)}
        placeholder={placeholder}
        className="pl-8 pr-8 h-8"
      />
      {local && (
        <Button
          variant="ghost"
          size="icon-xs"
          className="absolute right-1 top-1/2 -translate-y-1/2"
          onClick={() => {
            setLocal("");
            onChange("");
          }}
        >
          <X size={12} />
        </Button>
      )}
    </div>
  );
}
