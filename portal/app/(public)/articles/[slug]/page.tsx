"use client";

import { use } from "react";
import { useQuery } from "@tanstack/react-query";
import Image from "next/image";
import Link from "next/link";
import { ArrowLeft, Clock, User as UserIcon } from "lucide-react";
import { format } from "date-fns";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Skeleton } from "@/components/ui/skeleton";
import api from "@/lib/api";
import type { ApiResponse, CmsArticle } from "@/types";

export default function ArticleDetailPage({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = use(params);

  const { data: article, isLoading } = useQuery({
    queryKey: ["article", slug],
    queryFn: async () => {
      const res = await api.get<ApiResponse<CmsArticle>>(`/cms/articles/${slug}`);
      return res.data.data;
    },
  });

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8 max-w-3xl space-y-6">
        <Skeleton className="h-8 w-48" />
        <Skeleton className="aspect-video rounded-xl" />
        <Skeleton className="h-10 w-3/4" />
        <div className="space-y-3">
          {Array.from({ length: 6 }).map((_, i) => <Skeleton key={i} className="h-4 w-full" />)}
        </div>
      </div>
    );
  }

  if (!article) {
    return (
      <div className="container mx-auto px-4 py-20 text-center">
        <div className="text-5xl mb-4">📰</div>
        <h2 className="text-xl font-bold mb-2">Article not found</h2>
        <Button asChild variant="outline"><Link href="/articles">Back to articles</Link></Button>
      </div>
    );
  }

  return (
    <article className="container mx-auto px-4 py-8 max-w-3xl space-y-6">
      <Button variant="ghost" size="sm" asChild className="gap-1.5 -ml-2">
        <Link href="/articles"><ArrowLeft size={15} /> All Articles</Link>
      </Button>

      {article.cover_image_url && (
        <div className="relative aspect-video rounded-xl overflow-hidden bg-muted">
          <Image src={article.cover_image_url} alt={article.title} fill
            className="object-cover" sizes="(max-width: 768px) 100vw, 768px" priority />
        </div>
      )}

      <div className="space-y-3">
        {article.category && <Badge variant="secondary">{article.category}</Badge>}
        <h1 className="text-3xl font-bold leading-tight">{article.title}</h1>

        <div className="flex flex-wrap items-center gap-3 text-xs text-muted-foreground">
          {article.published_at && (
            <span className="flex items-center gap-1">
              <Clock size={12} />
              {format(new Date(article.published_at), "MMMM d, yyyy")}
            </span>
          )}
          {article.author && (
            <span className="flex items-center gap-1">
              <UserIcon size={12} />
              {article.author.full_name}
            </span>
          )}
        </div>

        {article.tags && article.tags.length > 0 && (
          <div className="flex flex-wrap gap-1.5">
            {article.tags.map((tag) => (
              <Badge key={tag} variant="outline" className="text-xs">{tag}</Badge>
            ))}
          </div>
        )}
      </div>

      {/* Prose content — render HTML or plain text */}
      {article.content && (
        <div
          className="prose prose-sm dark:prose-invert max-w-none"
          dangerouslySetInnerHTML={{ __html: article.content }}
        />
      )}
    </article>
  );
}
