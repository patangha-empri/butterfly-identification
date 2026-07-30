import type { Metadata } from "next";
import Link from "next/link";
import LegalPage, { LegalList, LegalSection } from "../../components/LegalPage";

export const metadata: Metadata = {
  title: "Privacy Statement — Pathanga",
  description:
    "What personal information Pathanga collects, how it is protected under the Digital Personal Data Protection Act 2023, and how to delete your account.",
};

export default function PrivacyPage() {
  return (
    <LegalPage
      plate="Plate B"
      title={
        <>
          Privacy
          <br />
          statement
        </>
      }
      lede="EMPRI respects the privacy of all users of Pathanga. This statement sets out what personal information the platform collects, why it is collected, how it is safeguarded, and how sensitive biodiversity locations are protected from misuse."
      current="/privacy"
    >
      <LegalSection n="§ 01" title="Personal information">
        <p>To use Pathanga, users may be requested to provide:</p>
        <LegalList items={["name", "email address"]} />
        <p>This information is collected solely for:</p>
        <LegalList
          items={[
            "user authentication",
            "account management",
            "technical support",
            "communication regarding observations",
            "improving platform services",
            "citizen science engagement",
          ]}
        />
      </LegalSection>

      <LegalSection n="§ 02" title="Privacy">
        <p>EMPRI respects the privacy of all users.</p>
        <p>
          Personal information will be processed in accordance with applicable Indian laws, including the Digital
          Personal Data Protection Act, 2023.
        </p>
        <p className="legal-callout">Personal information will never be sold for commercial purposes.</p>
        <p>
          EMPRI shall implement reasonable administrative and technical safeguards to protect personal information from
          unauthorised access, misuse or disclosure.
        </p>
      </LegalSection>

      <LegalSection n="§ 03" title="Sensitive biodiversity information">
        <p>To protect threatened species and fragile ecosystems, EMPRI reserves the right to:</p>
        <LegalList
          items={[
            "obscure exact geographic coordinates",
            "generalise observation locations",
            "restrict public visibility of sensitive observations",
          ]}
        />
        <p>This measure helps prevent illegal collection, habitat disturbance or exploitation.</p>
      </LegalSection>

      <LegalSection n="§ 04" title="Location information">
        <p>Location information provided by users may be used for:</p>
        <LegalList
          items={[
            "mapping species distributions",
            "ecological analyses",
            "conservation planning",
            "habitat suitability modelling",
            "biodiversity inventories",
            "climate change analysis",
          ]}
        />
        <p className="legal-callout">For sensitive species, exact coordinates may not be publicly displayed.</p>
      </LegalSection>

      <LegalSection n="§ 05" title="Artificial intelligence and analytics">
        <p>
          Pathanga may employ Artificial Intelligence, Machine Learning, Geographic Information Systems and other
          analytical tools to:
        </p>
        <LegalList
          items={[
            "identify butterfly species",
            "analyse spatial patterns",
            "monitor biodiversity trends",
            "detect climate-related changes",
            "support ecological modelling",
          ]}
        />
        <p>These analyses may use aggregated datasets.</p>
      </LegalSection>

      <LegalSection n="§ 06" title="Data sharing">
        <p>
          Individual observations may be shared with government departments, research organisations, universities,
          conservation organisations and national biodiversity databases. The full list, and the uses those datasets may
          be put to, are set out in the <Link href="/data-contribution">Data Contribution Statement</Link>.
        </p>
        <p className="legal-callout">
          Personal information of contributors will not be shared except where required by law or with explicit consent.
        </p>
      </LegalSection>

      <LegalSection n="§ 07" title="Account deletion">
        <p>Users may request deletion of their Pathanga account by contacting:</p>
        <p className="legal-address">
          Pathanga Support Team
          <br />
          Environmental Management &amp; Policy Research Institute (EMPRI)
          <br />
          Government of Karnataka
          <br />
          <a href="mailto:pathangaempri@gmail.com">pathangaempri@gmail.com</a>
        </p>
        <p>
          Upon verification, personal information associated with the account will be deleted, except where retention is
          required under applicable law or where anonymised data have already been incorporated into aggregated
          scientific datasets.
        </p>
      </LegalSection>

      <LegalSection n="§ 08" title="Contact">
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
