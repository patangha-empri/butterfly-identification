import type { Metadata } from "next";
import Link from "next/link";
import LegalPage, { LegalList, LegalSection } from "../../components/LegalPage";

export const metadata: Metadata = {
  title: "Terms of Use — Pathanga",
  description:
    "The conditions of using the Pathanga mobile application and website: user responsibilities, intellectual property, disclaimers and governing law.",
};

export default function TermsPage() {
  return (
    <LegalPage
      plate="Plate C"
      title={
        <>
          Terms
          <br />
          of use
        </>
      }
      lede="By registering, accessing or using the Pathanga mobile application or website, users agree to the terms outlined here and in the Data Contribution and Privacy statements."
      current="/terms"
    >
      <LegalSection n="§ 01" title="Acceptance">
        <p>
          Pathanga is a citizen science platform developed and maintained by the Environmental Management &amp; Policy
          Research Institute (EMPRI), Government of Karnataka.
        </p>
        <p>
          Use of the platform is subject to these Terms, together with the{" "}
          <Link href="/data-contribution">Data Contribution Statement</Link> and the{" "}
          <Link href="/privacy">Privacy Statement</Link>, which together form the Data Contribution, Privacy and Terms of
          Use Statement.
        </p>
      </LegalSection>

      <LegalSection n="§ 02" title="User responsibilities">
        <p>Users agree that they shall not:</p>
        <LegalList
          items={[
            "upload false observations",
            "upload copyrighted images without permission",
            "misuse another person's identity",
            "upload offensive or unlawful content",
            "intentionally manipulate biodiversity records",
          ]}
        />
        <p className="legal-callout">EMPRI reserves the right to suspend accounts violating these conditions.</p>
      </LegalSection>

      <LegalSection n="§ 03" title="Account deletion">
        <p>
          Users may request deletion of their Pathanga account by contacting the Pathanga Support Team. Upon
          verification, personal information associated with the account will be deleted, except where retention is
          required under applicable law or where anonymised data have already been incorporated into aggregated
          scientific datasets. See <Link href="/privacy">Privacy</Link> for the full procedure.
        </p>
      </LegalSection>

      <LegalSection n="§ 04" title="Intellectual property">
        <p>
          The Pathanga platform, software, logos, design, databases, documentation and associated materials are the
          intellectual property of EMPRI unless otherwise stated.
        </p>
        <p>Users may not reproduce or distribute the platform without prior written permission.</p>
        <p>
          Photographs uploaded by contributors remain the intellectual property of the respective contributors, subject
          to the licence described in the <Link href="/data-contribution">Data Contribution Statement</Link>.
        </p>
      </LegalSection>

      <LegalSection n="§ 05" title="Disclaimer">
        <p>
          Although every effort is made to ensure data quality, EMPRI does not guarantee the completeness, accuracy or
          suitability of contributed observations.
        </p>
        <p>AI-assisted identifications are advisory in nature.</p>
        <p className="legal-callout">Users should seek expert verification where taxonomic certainty is required.</p>
      </LegalSection>

      <LegalSection n="§ 06" title="Changes to these terms">
        <p>EMPRI reserves the right to revise these Terms and Conditions from time to time.</p>
        <p>Updated versions shall be published on the official Pathanga website and mobile application.</p>
        <p>Continued use of the platform constitutes acceptance of the revised terms.</p>
      </LegalSection>

      <LegalSection n="§ 07" title="Governing law">
        <p>These Terms shall be governed by the laws of India.</p>
        <p>
          Any disputes arising from the use of Pathanga shall be subject to the jurisdiction of the competent courts in
          Bengaluru, Karnataka.
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
