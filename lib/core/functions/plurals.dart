String thingOrThings(int things, String singularForm, String pluralEnding) {
  if (things <= 1) {
    return "$things $singularForm";
  } else {
    return "$things $singularForm$pluralEnding";
  }
}
