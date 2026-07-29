"use client";

import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import Link from "next/link";
import Image from "next/image";
import { format } from "date-fns";
import { Search, X, Clock } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Skeleton } from "@/components/ui/skeleton";
import api from "@/lib/api";
import type { ApiResponse, CmsArticle } from "@/types";

export default function ArticlesPage() {
  const [search, setSearch] = useState("");
  const [page, setPage] = useState(1);

  const { data, isLoading } = useQuery({
    queryKey: ["articles", search, page],
    queryFn: async () => {
      const params = new URLSearchParams({ page: String(page), per_page: "9", status: "published" });
      if (search) params.set("search", search);
      const res = await api.get<ApiResponse<CmsArticle[]>>(`/cms/articles?${params}`);
      return res.data;
    },
  });

  const articles = data?.data ?? [];
  const meta = data?.meta;

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      <div>
        <h1 className="text-2xl font-bold">Learn</h1>
        <p className="text-sm text-muted-foreground">Articles, guides, and resources about Indian butterflies</p>
      </div>

      <div className="relative max-w-sm">
        <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground" />
        <Input placeholder="Search articles…" value={search}
          onChange={(e) => { setSearch(e.target.value); setPage(1); }} className="pl-9 pr-8" />
        {search && (
          <button onClick={() => { setSearch(""); setPage(1); }}
            className="absolute right-2.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
            <X size={14} />
          </button>
        )}
      </div>

      {isLoading ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {Array.from({ length: 9 }).map((_, i) => (
            <Card key={i}><Skeleton className="aspect-video" /><CardContent className="p-4 space-y-2"><Skeleton className="h-5 w-3/4" /><Skeleton className="h-4 w-full" /></CardContent></Card>
          ))}
        </div>
      ) : articles.length === 0 ? (
        <div className="text-center py-20 text-muted-foreground">
          <div className="text-5xl mb-3">📰</div>
          <p>No articles yet. Check back soon!</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {articles.map((article) => (
            <Link key={article.id} href={`/articles/${article.slug}`}>
              <Card className="overflow-hidden hover:shadow-md transition-shadow group h-full flex flex-col">
                <div className="relative aspect-video bg-muted overflow-hidden">
                  {article.cover_image_url ? (
                    <Image src={article.cover_image_url} alt={article.title} fill
                      className="object-cover group-hover:scale-105 transition-transform duration-300" sizes="(max-width: 640px) 100vw, 33vw" />
                  ) : (
                    <div className="absolute inset-0 flex items-center justify-center text-4xl text-muted-foreground/30">📖</div>
                  )}
                </div>
                <CardContent className="p-4 flex flex-col flex-1 gap-2">
                  {article.category && <Badge variant="secondary" className="w-fit text-[10px]">{article.category}</Badge>}
                  <h2 className="font-semibold text-sm leading-snug line-clamp-2 flex-1">{article.title}</h2>
                  {article.summary && <p className="text-xs text-muted-foreground line-clamp-2">{article.summary}</p>}
                  <div className="flex items-center gap-1.5 text-[11px] text-muted-foreground mt-auto pt-2 border-t">
                    <Clock size={11} />
                    {article.published_at ? format(new Date(article.published_at), "MMM d, yyyy") : "Draft"}
                    {article.author && <span className="ml-auto">by {article.author.full_name}</span>}
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}

      {meta && meta.pages > 1 && (
        <div className="flex items-center justify-center gap-2 pt-4">
          <Button variant="outline" size="sm" disabled={!meta.has_prev} onClick={() => setPage((p) => p - 1)}>Previous</Button>
          <span className="text-sm text-muted-foreground">Page {meta.page} of {meta.pages}</span>
          <Button variant="outline" size="sm" disabled={!meta.has_next} onClick={() => setPage((p) => p + 1)}>Next</Button>
        </div>
      )}
    </div>
  );
}
