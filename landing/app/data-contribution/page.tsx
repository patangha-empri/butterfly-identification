import type { Metadata } from "next";
import Link from "next/link";
import LegalPage, { LegalList, LegalSection } from "../../components/LegalPage";

export const metadata: Metadata = {
  title: "Data Contribution Statement — Pathanga",
  description:
    "How observations contributed to Pathanga are used, owned, shared and verified. A citizen science platform by EMPRI, Government of Karnataka.",
};

export default function DataContributionPage() {
  return (
    <LegalPage
      plate="Plate A"
      title={
        <>
          Data
          <br />
          contribution
        </>
      }
      lede="Pathanga is a citizen science platform developed and maintained by the Environmental Management & Policy Research Institute (EMPRI), Government of Karnataka, to facilitate the collection, documentation, monitoring and dissemination of butterfly observations and associated biodiversity information."
      current="/data-contribution"
    >
      <LegalSection n="§ 00" title="About this statement">
        <p>
          The platform enables citizens, researchers, students, educational institutions, naturalists, government
          agencies and conservation organisations to voluntarily contribute biodiversity observations for scientific
          research, conservation planning, environmental education and climate change studies.
        </p>
        <p>
          By registering, accessing or using the Pathanga mobile application or website, users agree to the terms
          outlined in this Data Contribution, Privacy and Terms of Use Statement — set out across this page,{" "}
          <Link href="/privacy">Privacy</Link> and <Link href="/terms">Terms of Use</Link>.
        </p>
      </LegalSection>

      <LegalSection n="§ 01" title="Purpose of data collection">
        <p>The primary objectives of Pathanga are to:</p>
        <LegalList
          items={[
            "document butterfly diversity and distribution",
            "monitor seasonal and long-term changes in butterfly populations",
            "support biodiversity conservation and habitat restoration",
            "facilitate climate change impact assessments",
            "support ecological research",
            "promote citizen science participation",
            "strengthen environmental awareness and education",
            "assist government agencies in biodiversity planning and policy development",
          ]}
        />
      </LegalSection>

      <LegalSection n="§ 02" title="Data contribution">
        <p>Registered users may voluntarily contribute:</p>
        <LegalList
          items={[
            "butterfly photographs",
            "observations of butterfly behaviour",
            "life stage observations",
            "host plant information",
            "nectar plant information",
            "habitat information",
            "weather observations",
            "additional notes",
          ]}
        />
        <p>Users are encouraged to upload additional observations supported by photographs wherever possible.</p>
      </LegalSection>

      <LegalSection n="§ 03" title="AI-assisted species identification">
        <p>Pathanga may provide Artificial Intelligence (AI)-based species identification to assist users.</p>
        <p>
          AI-generated identifications are intended only as preliminary suggestions and should not be considered
          taxonomically definitive.
        </p>
        <p>Final verification may be performed by:</p>
        <LegalList items={["subject experts", "moderators", "authorised reviewers"]} />
        <p className="legal-callout">EMPRI does not guarantee 100% identification accuracy.</p>
      </LegalSection>

      <LegalSection n="§ 04" title="Ownership of contributed data">
        <p>Photographs uploaded by contributors remain the intellectual property of the respective contributors.</p>
        <p>
          By uploading photographs and associated biodiversity observations, contributors grant EMPRI a non-exclusive,
          royalty-free, perpetual licence to store, display, analyse, publish, archive, reproduce and use the submitted
          observations for:
        </p>
        <LegalList
          items={[
            "biodiversity monitoring",
            "scientific research",
            "climate change studies",
            "conservation planning",
            "environmental education",
            "awareness programmes",
            "government reports",
            "policy formulation",
            "academic publications",
            "non-commercial outreach activities",
          ]}
        />
        <p className="legal-callout">Ownership of photographs is not transferred to EMPRI.</p>
      </LegalSection>

      <LegalSection n="§ 05" title="Data sharing">
        <p>Individual observations may be shared with:</p>
        <LegalList
          items={[
            "Government of Karnataka departments",
            "Forest Department",
            "Karnataka Biodiversity Board",
            "educational institutions",
            "research organisations",
            "universities",
            "conservation organisations",
            "biodiversity authorities",
            "national biodiversity databases",
          ]}
        />
        <p>Data may also be integrated into:</p>
        <LegalList
          items={[
            "biodiversity atlases",
            "scientific publications",
            "environmental assessments",
            "climate vulnerability assessments",
            "conservation prioritisation exercises",
          ]}
        />
        <p className="legal-callout">
          Personal information of contributors will not be shared except where required by law or with explicit consent.
        </p>
      </LegalSection>

      <LegalSection n="§ 06" title="Data quality">
        <p>
          Contributors are responsible for ensuring that submitted observations are accurate to the best of their
          knowledge.
        </p>
        <p>EMPRI reserves the right to:</p>
        <LegalList
          items={[
            "review observations",
            "edit obvious errors",
            "reject improper submissions",
            "remove misleading information",
            "remove duplicate records",
          ]}
        />
      </LegalSection>

      <LegalSection n="§ 07" title="Research and publications">
        <p>Compiled datasets generated through Pathanga may be used for:</p>
        <LegalList
          items={[
            "scientific publications",
            "technical reports",
            "government publications",
            "climate change research",
            "biodiversity assessments",
            "environmental planning",
            "educational material",
            "conservation programmes",
          ]}
        />
        <p>
          Where practicable, contributors will be acknowledged. However, due to the large volume of observations,
          individual acknowledgement may not always be possible.
        </p>
      </LegalSection>

      <LegalSection n="§ 08" title="Citizen science contributions">
        <p>All contributions are voluntary.</p>
        <p>By contributing observations, users acknowledge that:</p>
        <LegalList
          items={[
            "observations become part of a larger citizen science database",
            "aggregated datasets may be analysed without seeking individual permission for every study",
            "data may contribute to scientific discoveries and conservation actions",
          ]}
        />
      </LegalSection>

      <LegalSection n="§ 09" title="Contact">
        <p className="legal-address">
          Pathanga Support
          <br />
          Environmental Management &amp; Policy Research Institute (EMPRI)
          <br />
          Department of Forest, Ecology and Environment
          <br />
          Government of Karnataka
          <br />
          <a href="mailto:pathangaempri@gmail.com">pathangaempri@gmail.com</a>
        </p>
      </LegalSection>
    </LegalPage>
  );
}
