// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:highlight/highlight.dart';
// ignore: implementation_imports
import 'package:highlight/src/mode.dart';
// ignore: implementation_imports
import 'package:highlight/src/common_modes.dart';

const _diagramKeywords =
    'graph flowchart flowcharttd flowchartlr flowchartbt flowchartrl flowcharttb '
    'sequencediagram sequencediagram-v2 statediagram statediagram-v2 '
    'classdiagram erdiagram gantt pie journey mindmap gitgraph';

const _controlKeywords =
    'subgraph section end loop alt opt else par rect note click default '
    'linkstyle style classdef class direction title acctitle accdescr activate '
    'deactivate participant actor critical over';

const _orientationKeywords = 'TB BT LR RL TD';

final mermaid = Mode(
  refs: {
    '~contains~0': Mode(
      className: 'title',
      relevance: 0,
      variants: [
        Mode(begin: r'\b[a-zA-Z_][\w-]*(?=\s*\[\[?)'),
        Mode(begin: r'\b[a-zA-Z_][\w-]*(?=\s*\(\(?)'),
        Mode(begin: r'\b[a-zA-Z_][\w-]*(?=\s*\{\{)'),
        Mode(begin: r'\b[a-zA-Z_][\w-]*(?=\s*:::)'),
        Mode(begin: r'\b[a-zA-Z_][\w-]*(?=\s*[:=])'),
      ],
    ),
  },
  aliases: ['mmd'],
  case_insensitive: true,
  lexemes: r'[a-zA-Z_][\w-]*',
  keywords: {
    'keyword': _diagramKeywords,
    'built_in': _controlKeywords,
    'literal': _orientationKeywords,
  },
  contains: [
    Mode(
      className: 'meta',
      begin: r'%%\{',
      end: r'\}%%',
      contains: [
        Mode(
          className: 'number',
          begin: r'-?\b\d+(\.\d+)?',
          relevance: 0,
        ),
        QUOTE_STRING_MODE,
        APOS_STRING_MODE,
      ],
    ),
    Mode(
      className: 'comment',
      begin: '%%',
      end: r'$',
      relevance: 0,
    ),
    Mode(
      className: 'keyword',
      begin:
          r'^\s*(graph|flowchart|sequencediagram|classdiagram|statediagram|erdiagram|gantt|pie|journey|mindmap|gitgraph)\b',
      relevance: 10,
    ),
    Mode(
      className: 'keyword',
      begin:
          r'\b(subgraph|section|loop|alt|opt|else|par|rect|note|click|linkstyle|style|classdef|class|direction|title|acctitle|accdescr|activate|deactivate|participant|actor|critical|default|over)\b',
      relevance: 2,
    ),
    Mode(ref: '~contains~0'),
    Mode(
      className: 'attr',
      begin: ':::[a-zA-Z0-9_-]+',
      relevance: 0,
    ),
    Mode(
      className: 'string',
      variants: [
        Mode(
          begin: r'\[\[?',
          end: r'\]\]?',
          excludeBegin: true,
          excludeEnd: true,
          contains: [BACKSLASH_ESCAPE],
        ),
        Mode(
          begin: r'\(\(?',
          end: r'\)\)?',
          excludeBegin: true,
          excludeEnd: true,
          contains: [BACKSLASH_ESCAPE],
        ),
        Mode(
          begin: r'\{\{',
          end: r'\}\}',
          excludeBegin: true,
          excludeEnd: true,
          contains: [BACKSLASH_ESCAPE],
        ),
        Mode(
          begin: r'\|',
          end: r'\|',
          excludeBegin: true,
          excludeEnd: true,
          contains: [BACKSLASH_ESCAPE],
        ),
        QUOTE_STRING_MODE,
        APOS_STRING_MODE,
      ],
    ),
    Mode(
      className: 'number',
      begin: r'-?\b\d+(\.\d+)?',
      relevance: 0,
    ),
    Mode(
      className: 'symbol',
      begin:
          r'(?:<{0,2}-+(?:\.?-+)*>{0,2})|(?:={2,}(?:>{1,2})?)|(?:-{2}[ox]|[ox]-{2})|:::|\|\||\+\+',
      relevance: 0,
    ),
  ],
);
