/**
 * Shared by the upload control and the edit dialog so the two cannot drift.
 * Mirrors ALLOWED_IMAGE_EXTENSIONS and MAX_CONTENT_LENGTH in the backend
 * (backend/app/utils/validators.py, backend/config.py).
 */
export const IMAGE_ACCEPT = ".jpg,.jpeg,.png,.webp";
export const MAX_IMAGE_BYTES = 10 * 1024 * 1024;

export const IMAGE_TYPES = [
  { value: "reference", label: "Reference" },
  { value: "male", label: "Male" },
  { value: "female", label: "Female" },
  { value: "upperside", label: "Upperside" },
  { value: "underside", label: "Underside" },
  { value: "egg", label: "Egg" },
  { value: "larva", label: "Larva" },
  { value: "pupa", label: "Pupa" },
  { value: "habitat", label: "Habitat" },
];
