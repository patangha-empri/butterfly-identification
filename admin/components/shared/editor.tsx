"use client";

import { useEffect, useRef, useState } from "react";
import type EditorJS from "@editorjs/editorjs";
import { getToken } from "@/lib/auth";

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

        const token = getToken();

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
                endpoints: {
                  byFile: `${process.env.NEXT_PUBLIC_API_URL ?? "https://staging.thirdeyegfx.in/butterfly_backend"}/api/v1/admin/cms/articles/upload-image`,
                },
                field: "image",
                additionalRequestHeaders: {
                  Authorization: token ? `Bearer ${token}` : "",
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
