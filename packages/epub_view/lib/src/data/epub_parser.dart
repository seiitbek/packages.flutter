import 'package:epub_view/src/data/epub_cfi_reader.dart';
import 'package:html/dom.dart' as dom;

import 'models/paragraph.dart';

export 'package:epubx/epubx.dart' hide Image;

List<EpubChapter> parseChapters(EpubBook epubBook) =>
    epubBook.Chapters!.fold<List<EpubChapter>>(
      [],
      (acc, next) {
        acc.add(next);
        next.SubChapters!.forEach(acc.add);
        return acc;
      },
    );

List<dom.Element> convertDocumentToElements(dom.Document document) =>
    document.getElementsByTagName('body').first.children;

List<dom.Element> _removeAllDiv(List<dom.Element> elements) {
  final List<dom.Element> result = [];

  for (final node in elements) {
    if (node.localName == 'div' && node.children.length > 1) {
      result.addAll(_removeAllDiv(node.children));
    } else {
      result.add(node);
    }
  }

  return result;
}

ParseParagraphsResult parseParagraphs(
  List<EpubChapter> chapters,
  EpubContent? content,
) {
  String? filename = '';
  final List<int> chapterIndexes = [];
  final paragraphs = chapters.fold<List<Paragraph>>(
    [],
    (acc, next) {
      List<dom.Element> elmList = [];
      if (filename != next.ContentFileName) {
        filename = next.ContentFileName;
        final document = EpubCfiReader().chapterDocument(next);
        if (document != null) {
          final result = convertDocumentToElements(document);
          elmList = _removeAllDiv(result);
        }
      }

      if (next.Anchor == null) {
        // last element from document index as chapter index
        chapterIndexes.add(acc.length);
        acc.addAll(elmList
            .map((element) => Paragraph(element, chapterIndexes.length - 1)));
        return acc;
      } else {
        final index = elmList.indexWhere(
          (elm) => elm.outerHtml.contains(
            'id="${next.Anchor}"',
          ),
        );
        if (index == -1) {
          chapterIndexes.add(acc.length);
          acc.addAll(elmList
              .map((element) => Paragraph(element, chapterIndexes.length - 1)));
          return acc;
        }

        chapterIndexes.add(index);
        acc.addAll(elmList
            .map((element) => Paragraph(element, chapterIndexes.length - 1)));
        return acc;
      }
    },
  );

  return ParseParagraphsResult(paragraphs, chapterIndexes);
}

List<Pages> parsePages(List<EpubChapter> chapters, int maxCharactersPerPage) {
  final List<Pages> pages = [];
  List<dom.Element> currentPage = [];
  int currentCharacterCount = 0;

  for (final chapter in chapters) {
    final document = EpubCfiReader().chapterDocument(chapter);
    if (document != null) {
      final chapterElements = convertDocumentToElements(document);
      final remainingElements = [...chapterElements];

      while (remainingElements.isNotEmpty) {
        final element = remainingElements.removeAt(0);
        final elementText = element.text; // Get the text content of the element
        final elementSize = elementText.length;

        if (currentCharacterCount + elementSize <= maxCharactersPerPage) {
          currentPage.add(element);
          currentCharacterCount += elementSize;
        } else {
          pages.add(Pages(List.from(currentPage)));
          currentPage.clear();
          currentPage.add(element);
          currentCharacterCount = elementSize;
        }
      }
    }
  }

  if (currentPage.isNotEmpty) {
    pages.add(Pages(List.from(currentPage)));
  }

  return pages;
}

class Pages {
  final List<dom.Element> elements;

  Pages(this.elements);
}

class ParseParagraphsResult {
  ParseParagraphsResult(this.flatParagraphs, this.chapterIndexes);

  final List<Paragraph> flatParagraphs;
  final List<int> chapterIndexes;
}
