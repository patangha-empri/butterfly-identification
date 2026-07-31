import ObservationDetailPage from "./page_client";

export async function generateStaticParams() {
  return [{ id: "id" }];
}

export default function Page({ params }: { params: Promise<{ id: string }> }) {
  return <ObservationDetailPage params={params} />;
}
