/// Formats a price the way the Figma designs do, for example `4000 pkr`.
///
/// The designs use Pakistani Rupees. No locale-aware grouping is applied so the
/// output matches the reference screenshots exactly.
String formatPkr(int amount) => '$amount pkr';