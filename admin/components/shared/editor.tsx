"use client";

import { useEffect, useRef, useState } from "react";
import type EditorJS from "@editorjs/editorjs";
import { API_BASE_URL, ensureAccessToken } from "@/lib/session";

interface EditorProps {
  value: string; // JSON string
  onChange: (value: string) => void;
  placeholder?: string;
  readOnly?: boolean;
}

export function Editor({
  value,
  onChange,
  placeholder = "Start writing your article...",
  readOnly = false,
}: EditorProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const editorRef = useRef<EditorJS | null>(null);
  const onChangeRef = useRef(onChange);
  onChangeRef.current = onChange;

  useEffect(() => {
    if (typeof window === "undefined" || !containerRef.current || editorRef.current) return;

    const initEditor = async () => {
      try {
        const EditorJSClass = (await import("@editorjs/editorjs")).default;
        const HeaderClass = (await import("@editorjs/header")).default;
        const ListClass = (await import("@editorjs/list")).default;
        const ImageClass = (await import("@editorjs/image")).default;

        let parsedData: any = undefined;
        if (value) {
          try {
            parsedData = JSON.parse(value);
          } catch (e) {
            // Fallback for legacy plain text/HTML
            parsedData = {
              blocks: [
                {
                  type: "paragraph",
                  data: {
                    text: value,
                  },
                },
              ],
            };
          }
        }

        const editor = new EditorJSClass({
          holder: containerRef.current!,
          placeholder,
          readOnly,
          data: parsedData,
          async onChange(api) {
            const savedData = await api.saver.save();
            onChangeRef.current(JSON.stringify(savedData));
          },
          tools: {
            header: {
              class: HeaderClass as any,
              inlineToolbar: true,
              config: {
                placeholder: "Header",
                levels: [2, 3, 4],
                defaultLevel: 2,
              },
            },
            list: {
              class: ListClass as any,
              inlineToolbar: true,
              config: {
                defaultStyle: "unordered",
              },
            },
            image: {
              class: ImageClass as any,
              config: {
                // A custom uploader rather than `endpoints.byFile`, because
                // that form only accepts static `additionalRequestHeaders`
                // captured at mount. An article editor stays open for a long
                // time, so a token baked in here is stale by the time anyone
                // drops an image in — the upload 401s while the rest of the
                // page still works. Resolving the token per upload means it is
                // always live, refreshed first if need be.
                uploader: {
                  async uploadByFile(file: File) {
                    const token = await ensureAccessToken();
                    const body = new FormData();
                    body.append("image", file);

                    const res = await fetch(
                      `${API_BASE_URL}/admin/cms/articles/upload-image`,
                      {
                        method: "POST",
                        body,
                        headers: token ? { Authorization: `Bearer ${token}` } : {},
                      }
                    );
                    if (!res.ok) return { success: 0 };

                    const json = (await res.json()) as {
                      data?: { url?: string };
                      file?: { url?: string };
                    };
                    const url = json.data?.url ?? json.file?.url;
                    return url ? { success: 1, file: { url } } : { success: 0 };
                  },
                },
              },
            },
          },
        });

        editorRef.current = editor;
      } catch (err) {
        console.error("Failed to initialize Editor.js", err);
      }
    };

    initEditor();

    return () => {
      if (editorRef.current) {
        try {
          editorRef.current.destroy();
        } catch (e) {}
        editorRef.current = null;
      }
    };
  }, [placeholder, readOnly]); // Run only on initial render container reference creation

  return (
    <div 
      ref={containerRef} 
      className="prose prose-sm dark:prose-invert max-w-none min-h-[300px] border border-input rounded-md px-3 py-2 bg-background focus-within:ring-1 focus-within:ring-ring focus-within:border-ring" 
    />
  );
}
