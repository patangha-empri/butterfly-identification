/// ─────────────────────────────────────────────────────────────────────────────
/// LEGAL CONTENT
/// In-app copies of the policy documents. This is starter/template wording —
/// have it reviewed by a legal professional and keep it in sync with the
/// canonical web versions before public release.
/// ─────────────────────────────────────────────────────────────────────────────

class LegalSection {
  const LegalSection(this.heading, this.body);
  final String heading;
  final String body;
}

class LegalDoc {
  const LegalDoc({
    required this.title,
    required this.updated,
    required this.sections,
  });
  final String title;
  final String updated;
  final List<LegalSection> sections;
}

abstract class LegalContent {
  static const String _updated = 'Last updated: 29 May 2026';

  static const privacyPolicy = LegalDoc(
    title: 'Privacy Policy',
    updated: _updated,
    sections: [
      LegalSection('Overview',
          'Pathanga ("we", "the app") helps you record and identify butterfly sightings. This policy explains what we collect, why, and the choices you have. We collect only what we need to run the app.'),
      LegalSection('Information we collect',
          'Account details you provide (name, username, email). Content you create such as sightings, photos, notes, likes and comments. Optional location coordinates attached to a sighting when you choose to add them. Basic technical data needed to deliver the service.'),
      LegalSection('How we use your information',
          'To create and secure your account, store and display your sightings, run AI identification on photos you submit, show community content, and improve the app. We do not sell your personal information.'),
      LegalSection('Location data',
          'Location is used only to tag where a butterfly was seen and to show nearby sightings. You control whether a sighting includes coordinates, and you can mark sightings private or anonymous.'),
      LegalSection('Photos and AI identification',
          'Photos you upload are stored to display your sightings and may be sent to an AI identification service to suggest a species. Do not upload photos that contain other people or sensitive information.'),
      LegalSection('Sharing',
          'Public sightings are visible to other users. Private sightings are visible only to you and administrators. We share data with service providers only as needed to operate the app.'),
      LegalSection('Your choices',
          'You can edit your profile, change a sighting\'s privacy, delete your own content, and delete your account from Settings. Deleting your account deactivates it and removes your content from public view.'),
      LegalSection('Contact',
          'Questions about this policy can be sent to the support address listed on our website.'),
    ],
  );

  static const terms = LegalDoc(
    title: 'Terms & Conditions',
    updated: _updated,
    sections: [
      LegalSection('Acceptance',
          'By creating an account or using Pathanga you agree to these terms. If you do not agree, please do not use the app.'),
      LegalSection('Your account',
          'You are responsible for keeping your login secure and for activity on your account. Provide accurate information and keep it up to date.'),
      LegalSection('Your content',
          'You keep ownership of the sightings, photos and text you submit. You grant us a licence to host and display that content so the app can function, including showing public sightings to other users.'),
      LegalSection('Acceptable use',
          'Do not upload unlawful, harmful, or infringing content, attempt to disrupt the service, or misuse other users\' data. We may remove content or suspend accounts that break these terms.'),
      LegalSection('AI identification',
          'Species suggestions are generated automatically and may be wrong. They are guidance, not scientific confirmation. Always verify before relying on an identification.'),
      LegalSection('Availability',
          'The app is provided "as is". We work to keep it reliable but cannot guarantee uninterrupted or error-free service.'),
      LegalSection('Changes',
          'We may update these terms. Continued use after an update means you accept the revised terms.'),
    ],
  );

  static const communityGuidelines = LegalDoc(
    title: 'Community Guidelines',
    updated: _updated,
    sections: [
      LegalSection('Be a good naturalist',
          'Pathanga is a community of people who love butterflies. Be respectful, helpful and welcoming to beginners and experts alike.'),
      LegalSection('Post accurate sightings',
          'Submit your own photos and honest observations. Don\'t fabricate locations or pass off others\' photos as your own.'),
      LegalSection('Protect wildlife',
          'Never harm, bait, or disturb butterflies or their habitat to get a photo. Avoid sharing precise locations of rare or threatened species if it could put them at risk.'),
      LegalSection('Keep comments kind',
          'Constructive feedback on identifications is welcome. Harassment, hate speech, spam and self-promotion are not.'),
      LegalSection('Respect privacy',
          'Don\'t post photos of identifiable people without consent, or share anyone\'s personal information.'),
      LegalSection('Reporting',
          'If you see content that breaks these guidelines, report it. We review reports and may remove content or restrict accounts.'),
    ],
  );
}
