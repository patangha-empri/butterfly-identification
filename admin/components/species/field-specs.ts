/**
 * The species form described as data.
 *
 * The species table has ~60 editable columns after migration 001. Hand-writing
 * an input per column would be thousands of lines of near-identical JSX, so the
 * form renders from this spec instead. Adding a column here is all it takes to
 * expose it — but remember the matching Marshmallow field in
 * backend/app/schemas/admin.py, or the request 422s on unknown=RAISE.
 */

export type FieldKind =
  | "text"
  | "textarea"
  | "number"
  | "select"
  | "switch"
  | "list"
  | "months";

export interface FieldSpec {
  name: string;
  label: string;
  kind: FieldKind;
  placeholder?: string;
  help?: string;
  options?: { value: string; label: string }[];
  min?: number;
  max?: number;
  step?: number;
  rows?: number;
  /** Full-width on the 2-column grid. */
  wide?: boolean;
}

export interface SectionSpec {
  id: string;
  title: string;
  description: string;
  fields: FieldSpec[];
  /** Only Basics starts open — 60 inputs at once is unusable. */
  defaultOpen?: boolean;
}

export const CONSERVATION_OPTIONS = [
  { value: "LC", label: "LC — Least Concern" },
  { value: "NT", label: "NT — Near Threatened" },
  { value: "VU", label: "VU — Vulnerable" },
  { value: "EN", label: "EN — Endangered" },
  { value: "CR", label: "CR — Critically Endangered" },
  { value: "EW", label: "EW — Extinct in the Wild" },
  { value: "EX", label: "EX — Extinct" },
];

const IUCN_OPTIONS = [
  { value: "DD", label: "DD — Data Deficient" },
  ...CONSERVATION_OPTIONS,
  { value: "NE", label: "NE — Not Evaluated" },
];

const DATA_VERIFICATION_OPTIONS = [
  { value: "unverified", label: "Unverified" },
  { value: "needs_review", label: "Needs review" },
  { value: "verified", label: "Verified" },
  { value: "disputed", label: "Disputed" },
];

export const SPECIES_SECTIONS: SectionSpec[] = [
  {
    id: "basics",
    title: "Basics",
    description: "The minimum needed to save a species.",
    defaultOpen: true,
    fields: [
      { name: "common_name", label: "Common name", kind: "text", placeholder: "Great Orange Tip" },
      { name: "scientific_name", label: "Scientific name", kind: "text", placeholder: "Hebomoia glaucippe", help: "Must be unique across all species." },
      { name: "family", label: "Family", kind: "text", placeholder: "Pieridae" },
      { name: "genus", label: "Genus", kind: "text", placeholder: "Hebomoia" },
      { name: "description", label: "Description", kind: "textarea", rows: 4, wide: true },
      { name: "habitat", label: "Habitat", kind: "textarea", rows: 3, wide: true },
      { name: "conservation_status", label: "Conservation status", kind: "select", options: CONSERVATION_OPTIONS },
    ],
  },
  {
    id: "taxonomy",
    title: "Taxonomy",
    description: "Classification beyond family and genus, and naming history.",
    fields: [
      { name: "subfamily", label: "Subfamily", kind: "text" },
      { name: "tribe", label: "Tribe", kind: "text" },
      { name: "species_epithet", label: "Species epithet", kind: "text" },
      { name: "subspecies", label: "Subspecies", kind: "text" },
      { name: "authority", label: "Authority", kind: "text", help: "Who first described it, e.g. Linnaeus." },
      { name: "taxon_year", label: "Year described", kind: "number", min: 1700, max: new Date().getFullYear() },
      { name: "accepted_name", label: "Accepted name", kind: "text", help: "Fill in if this name is now a synonym of another." },
      { name: "synonyms", label: "Synonyms", kind: "list", wide: true },
      { name: "taxonomic_notes", label: "Taxonomic notes", kind: "textarea", rows: 3, wide: true },
    ],
  },
  {
    id: "morphology",
    title: "Appearance & identification",
    description: "How to recognise it in the field, including sex differences.",
    fields: [
      { name: "identification_notes", label: "Identification notes", kind: "textarea", rows: 3, wide: true },
      { name: "male_description", label: "Male", kind: "textarea", rows: 3 },
      { name: "female_description", label: "Female", kind: "textarea", rows: 3 },
      { name: "upperside_description", label: "Upperside", kind: "textarea", rows: 3 },
      { name: "underside_description", label: "Underside", kind: "textarea", rows: 3 },
      { name: "wing_pattern", label: "Wing pattern", kind: "textarea", rows: 2, wide: true },
      { name: "wing_colour", label: "Wing colour", kind: "text" },
      { name: "body_colour", label: "Body colour", kind: "text" },
      { name: "wing_span_min_mm", label: "Wingspan min (mm)", kind: "number", min: 5, max: 400 },
      { name: "wing_span_max_mm", label: "Wingspan max (mm)", kind: "number", min: 5, max: 400 },
      { name: "body_length_min_mm", label: "Body length min (mm)", kind: "number", min: 1, max: 500 },
      { name: "body_length_max_mm", label: "Body length max (mm)", kind: "number", min: 1, max: 500 },
      { name: "color_tags", label: "Colour tags", kind: "list", wide: true, help: "Used by the app's colour filter — lowercase single words work best." },
    ],
  },
  {
    id: "lifecycle",
    title: "Lifecycle & flight",
    description: "Life stages, and when adults are on the wing.",
    fields: [
      { name: "seasonal_appearance", label: "Flight months", kind: "months", wide: true, help: "Months adults are seen. Drives the app's seasonal filter." },
      { name: "is_migratory", label: "Migratory", kind: "switch" },
      { name: "flight_period", label: "Flight period", kind: "text", help: "In words, e.g. “Year-round, peaking after monsoon”." },
      { name: "breeding_season", label: "Breeding season", kind: "text" },
      { name: "life_cycle", label: "Life cycle", kind: "textarea", rows: 3, wide: true },
      { name: "egg_description", label: "Egg", kind: "textarea", rows: 2 },
      { name: "larva_description", label: "Larva / caterpillar", kind: "textarea", rows: 2 },
      { name: "pupa_description", label: "Pupa / chrysalis", kind: "textarea", rows: 2 },
      { name: "adult_description", label: "Adult", kind: "textarea", rows: 2 },
    ],
  },
  {
    id: "ecology",
    title: "Ecology & distribution",
    description: "Where it lives, what it feeds on, and how it behaves.",
    fields: [
      { name: "nectar_plants", label: "Nectar plants", kind: "list", wide: true },
      { name: "forest_type", label: "Forest type", kind: "text" },
      { name: "altitude_min_m", label: "Altitude min (m)", kind: "number", min: -500, max: 9000 },
      { name: "altitude_max_m", label: "Altitude max (m)", kind: "number", min: -500, max: 9000 },
      { name: "behaviour", label: "Behaviour", kind: "textarea", rows: 3, wide: true },
      { name: "migration_notes", label: "Migration notes", kind: "textarea", rows: 2, wide: true },
      { name: "predators", label: "Predators", kind: "textarea", rows: 2, wide: true },
      { name: "countries", label: "Countries", kind: "list", wide: true },
      { name: "protected_areas", label: "Protected areas", kind: "list", wide: true },
    ],
  },
  {
    id: "conservation",
    title: "Conservation & legal status",
    description: "IUCN assessment and legal protection.",
    fields: [
      { name: "iucn_status", label: "IUCN status", kind: "select", options: IUCN_OPTIONS },
      { name: "iucn_assessment_url", label: "IUCN assessment URL", kind: "text" },
      { name: "legal_protection", label: "Legal protection", kind: "textarea", rows: 3, wide: true, help: "e.g. Wildlife Protection Act schedule." },
    ],
  },
  {
    id: "knowledge",
    title: "Notes & sources",
    description: "Supporting material and where this record's data came from.",
    fields: [
      { name: "interesting_facts", label: "Interesting facts", kind: "textarea", rows: 3, wide: true },
      { name: "research_notes", label: "Research notes", kind: "textarea", rows: 3, wide: true },
      { name: "citations", label: "Citations", kind: "list", wide: true },
      { name: "source_urls", label: "Source URLs", kind: "list", wide: true },
      { name: "data_source", label: "Data source", kind: "text", help: "Where this record originated, e.g. GBIF." },
      { name: "verification_status", label: "Data verification", kind: "select", options: DATA_VERIFICATION_OPTIONS, help: "How well checked this record is — unrelated to observation verification." },
      { name: "confidence_score", label: "Confidence (0–1)", kind: "number", min: 0, max: 1, step: 0.05 },
    ],
  },
];

/** Every field name the form owns, used to build the request payload. */
export const ALL_FIELD_SPECS: FieldSpec[] = SPECIES_SECTIONS.flatMap((s) => s.fields);

export const REQUIRED_FIELDS = ["common_name", "scientific_name", "family", "genus"] as const;
