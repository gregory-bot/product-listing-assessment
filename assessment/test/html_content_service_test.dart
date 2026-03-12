import 'package:flutter_test/flutter_test.dart';
import 'package:winp_flux_assessment/services/html_content_service.dart';

void main() {
  group('HtmlContentService', () {
    late HtmlContentService service;

    setUp(() {
      service = HtmlContentService();
    });

    test('stripTags removes all HTML tags', () {
      final html = '<p>Hello <strong>world</strong>!</p>';
      final result = service.stripTags(html);
      expect(result, 'Hello world!');
    });

    test('stripTags handles nested tags', () {
      final html = '<div><p>Nested <span>content</span></p></div>';
      final result = service.stripTags(html);
      expect(result, 'Nested content');
    });

    test('stripTags trims whitespace from result', () {
      final html = '   <p>Trimmed</p>   ';
      final result = service.stripTags(html);
      expect(result, 'Trimmed');
    });

    test('stripTags returns empty string for empty HTML', () {
      final result = service.stripTags('');
      expect(result, '');
    });

    test('stripTags handles self-closing tags', () {
      final html = '<p>Line 1<br/>Line 2</p>';
      final result = service.stripTags(html);
      expect(result, 'Line 1Line 2');
    });

    test('hasBlockContent returns true for paragraph tags', () {
      final html = '<p>This is a paragraph</p>';
      expect(service.hasBlockContent(html), isTrue);
    });

    test('hasBlockContent returns true for div, ul, ol, and heading tags', () {
      expect(service.hasBlockContent('<div>Content</div>'), isTrue);
      expect(service.hasBlockContent('<ul><li>Item</li></ul>'), isTrue);
      expect(service.hasBlockContent('<ol><li>Item</li></ol>'), isTrue);
      expect(service.hasBlockContent('<h1>Title</h1>'), isTrue);
      expect(service.hasBlockContent('<h2>Subtitle</h2>'), isTrue);
      expect(service.hasBlockContent('<h6>Small title</h6>'), isTrue);
    });

    test('hasBlockContent returns false for inline tags', () {
      final html = '<span>Inline content</span>';
      expect(service.hasBlockContent(html), isFalse);
    });

    test('hasBlockContent is case-insensitive', () {
      expect(service.hasBlockContent('<P>Paragraph</P>'), isTrue);
      expect(service.hasBlockContent('<DIV>Content</DIV>'), isTrue);
      expect(service.hasBlockContent('<SPAN>Span</SPAN>'), isFalse);
    });
  });
}
