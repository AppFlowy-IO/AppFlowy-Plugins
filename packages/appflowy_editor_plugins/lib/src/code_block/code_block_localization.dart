class CodeBlockLocalizations {
  const CodeBlockLocalizations({
    this.codeBlockNewParagraph =
        "Insert a new paragraph next to the code block",
    this.codeBlockAddTwoSpaces =
        "Insert two spaces at the line start in code block",
    this.codeBlockDeleteTwoSpaces =
        "Delete two spaces at the line start in code block",
    this.codeBlockSelectAll = "Select all content inside a code block",
    this.codeBlockPasteText = "Paste text in codeblock",
    this.language = "Language",
    this.languagePlaceholder = "Select a language",
    this.autoLanguage = "Auto",
    this.copyTooltip = "Copy contents of the code block",
  });

  // Shortcut descriptions
  final String codeBlockNewParagraph;
  final String codeBlockAddTwoSpaces;
  final String codeBlockDeleteTwoSpaces;
  final String codeBlockSelectAll;
  final String codeBlockPasteText;

  final String language;
  final String languagePlaceholder;
  final String autoLanguage;
  final String copyTooltip;
}
