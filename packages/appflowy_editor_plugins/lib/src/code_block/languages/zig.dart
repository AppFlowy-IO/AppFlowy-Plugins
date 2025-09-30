// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:highlight/highlight.dart';
// ignore: implementation_imports
import 'package:highlight/src/mode.dart';
// ignore: implementation_imports
import 'package:highlight/src/common_modes.dart';

final zig = Mode(
  refs: {},
  aliases: ['zign'],
  case_insensitive: false,
  keywords: 'void bool i8 u8 i16 u16 i32 u32 i64 u64 i128 u128 isize usize '
      'f16 f32 f64 f128 c_char c_short c_ushort c_int c_uint c_long c_ulong '
      'c_longlong c_ulonglong c_longdouble anytype anyframe noreturn type error '
      'comptime_int comptime_float const var extern packed export pub fn inline noinline '
      'callconv stdcallcc ccc volatile allowzero align linksection threadlocal '
      'struct enum union opaque error try catch orelse errdefer defer async await suspend '
      'resume cancel nosuspend if else switch while for break continue return usingnamespace '
      'test or and not xor orelse',
  contains: [
    C_LINE_COMMENT_MODE,
    C_BLOCK_COMMENT_MODE,
    Mode(
      className: 'string',
      variants: [
        QUOTE_STRING_MODE,
        Mode(
          begin: 'c"',
          end: '"',
          contains: [BACKSLASH_ESCAPE],
          relevance: 10,
        ),
      ],
    ),
    APOS_STRING_MODE,
    Mode(
      className: 'number',
      variants: [
        Mode(begin: r'\b0b[01_]+'), // 0b11_00
        Mode(begin: r'\b0o[0-7_]+'), // 0o77_00
        Mode(begin: r'\b0x[0-9a-fA-F_]+'), // 0xff_00
        Mode(
          begin:
              r'\b\d([\d_]*\d)?(\.\d([\d_]*\d)?)?([eE][+-]?\d([\d_]*\d)?)?[fF]?',
        ),
      ],
      relevance: 0,
    ),
    Mode(
      className: 'meta',
      begin: '@',
      end: r'\s| $',
      excludeEnd: true,
      keywords:
          '@import @cImport @cInclude @cDefine @cUndef @compileError @compileLog '
          '@setEvalBranchQuota @setRuntimeSafety @sqrt @sin @cos @tan @exp @exp2 @log @log2 @log10 '
          '@fabs @floor @ceil @trunc @round @sub @add @mul @div @rem @mod @bitAnd @bitOr @bitXor '
          '@shl @shr @bitNot @byteSwap @bitReverse @clz @ctz @popCount @alignOf @bitSizeOf @sizeOf '
          '@offsetOf @typeInfo @typeName @embedFile @errorName @errorReturnTrace @frame @Frame @frameAddress '
          '@intCast @floatCast @ptrCast @truncate @boolToInt @enumToInt @intToFloat @floatToInt @intToPtr '
          '@ptrToInt @intToError @errorToInt @intToEnum @src @panic @tagName @fieldParentPtr @byteOffsetOf '
          '@divExact @divTrunc @divFloor @mod @rem @sqrt @sin @cos @tan @exp @exp2 @log @log2 @log10 @fabs '
          '@floor @ceil @trunc @round @asyncCall @call @frame @Frame @frameAddress @breakpoint @returnAddress '
          '@disableInstrumentation @setCold @setRuntimeSafety @setFloatMode @atomicLoad @atomicStore @atomicRmw '
          '@atomicFence @cmpxchgStrong @cmpxchgWeak @fence @bitCast @reduce @shuffle @select @splat',
    ),
  ],
);
