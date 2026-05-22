const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const l10nDir = path.join(root, 'lib/l10n');
const outPath = path.join(root, 'lib/app/arb_translations.dart');

const locales = ['en', 'hu', 'de', 'es'];

function readArb(locale) {
  const filePath = path.join(l10nDir, `app_${locale}.arb`);
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function sourceFromDescription(value) {
  const prefix = 'Source text: ';
  if (!value || typeof value.description !== 'string') return null;
  if (!value.description.startsWith(prefix)) return null;
  return value.description.slice(prefix.length);
}

const byLocale = {};
for (const locale of locales) {
  const arb = readArb(locale);
  byLocale[locale] = {};
  for (const [key, value] of Object.entries(arb)) {
    if (!key.startsWith('@m')) continue;
    const messageId = key.slice(1);
    const source = sourceFromDescription(value);
    if (!source || typeof arb[messageId] !== 'string') continue;
    byLocale[locale][source] = arb[messageId];
  }
}

const sources = [...new Set(locales.flatMap((locale) => Object.keys(byLocale[locale])))]
  .sort((a, b) => a.localeCompare(b));

const fallbackReport = {};
for (const locale of locales) {
  fallbackReport[locale] = [];
  const arb = {
    '@@locale': locale,
    appTitle: 'Mealr',
    '@appTitle': { description: 'Application title' },
  };
  sources.forEach((source, index) => {
    const messageId = `m${String(index + 1).padStart(4, '0')}`;
    let value = byLocale[locale][source];
    if (value == null) {
      value = byLocale.en[source] ?? byLocale.hu[source] ?? source;
      fallbackReport[locale].push(source);
    }
    arb[messageId] = value;
    arb[`@${messageId}`] = {
      description: `Source text: ${source}`,
    };
  });
  fs.writeFileSync(
    path.join(l10nDir, `app_${locale}.arb`),
    `${JSON.stringify(arb, null, 2)}\n`,
  );
}

function dartString(value) {
  return JSON.stringify(value)
    .replace(/\$/g, '\\$')
    .replace(/</g, '\\u003c')
    .replace(/>/g, '\\u003e');
}

let dart = `// Generated from lib/l10n/*.arb by tool/sync_l10n_from_arb.js.\n`;
dart += `// Keep ARB files as the localization source of truth.\n\n`;
dart += `const arbTranslations = <String, Map<String, String>>{\n`;
for (const locale of locales) {
  dart += `  '${locale}': <String, String>{\n`;
  const entries = sources.map((source) => [
    source,
    byLocale[locale][source] ?? byLocale.en[source] ?? byLocale.hu[source] ?? source,
  ]);
  for (const [source, value] of entries) {
    dart += `    ${dartString(source)}: ${dartString(value)},\n`;
  }
  dart += `  },\n`;
}
dart += `};\n`;
fs.writeFileSync(outPath, dart);

console.log(`Synced ${sources.length} localized messages from ARB files.`);
for (const locale of locales) {
  if (fallbackReport[locale].length === 0) continue;
  console.log(`${locale}: ${fallbackReport[locale].length} fallback message(s)`);
}
