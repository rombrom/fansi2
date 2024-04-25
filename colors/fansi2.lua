-- ---------------------------------------------------------------------------
-- FANSI2: Because ANSI can be fancy
-- ---------------------------------------------------------------------------
-- Note: although this theme aims to be used with your terminal color palette,
--       there are a few assumptions made to make the color scheme work as
--       required. These are:
--       1. Default foreground and background colors are not in ANSI colors and
--          are set to the highlight color NONE. This allows the color scheme
--          to have 18 colors total.
--       2. 'Bright Black' (9) is significantly (>= 20%) brighter than black.
--          It's used for line numbers and other textual elements.

-- ---------------------------------------------------------------------------
-- Utils
-- ---------------------------------------------------------------------------

-- Reduces over all values in a list.
local function reduce(list, reducer, initial)
  local accumulator = initial

  for _, value in ipairs(list) do
    accumulator = reducer(accumulator, value)
  end

  return accumulator
end

-- Get attributes from a definition.
--
-- Attributes can be any boolean definition as documented as {val}
-- in the `:h nvim_set_hl()` documentation.
local function get_attrs(definition)
  if not definition.attrs then return {} end

  return reduce(definition.attrs, function(attrs, value)
    attrs[value] = true
    return attrs
  end, {})
end

-- Get colors from a definition
--
-- If `fg` or `bg` is found, set the `fg`, `bg`, `ctermfg` and `ctermbg`
-- keys accordingly to be consumed by `:h nvim_set_hl()`.
-- The `sp` key isn't supported in `notermguicolors`.
local function get_colors(definition)
  local colors = {}

  if definition.bg then
    colors.ctermbg = definition.bg[1]
    colors.bg = definition.bg[2]
  end

  if definition.fg then
    colors.ctermfg = definition.fg[1]
    colors.fg = definition.fg[2]
  end

  if definition.sp then
    colors.sp = definition.sp[2]
  end

  return colors
end

-- Returns a group definition as per `:h nvim_set_hl()`
local function get_group(definition)
  if type(definition) == 'string' then return { link = definition } end

  local attrs = get_attrs(definition)
  local colors = get_colors(definition)

  return vim.tbl_extend('force', attrs, colors)
end

-- ---------------------------------------------------------------------------
-- Palette
-- ---------------------------------------------------------------------------
-- 1 = cterm color
-- 2 = gui color
local palette = {
  bg = { 'none', '#181b1f' },
  fg = { 'none', '#fff1d6' },
  black = {0, '#31373d' },
  blackLight = {8, '#757d85' },
  red = {1, '#f55c45' },
  redLight = {9, '#f58c31' },
  green = {2, '#afb833' },
  greenLight = {10, '#d6d66f' },
  yellow = {3, '#ebb242' },
  yellowLight = {11, '#ffd37a' },
  blue = {4, '#5fb8b8' },
  blueLight = {12, '#92d6d6' },
  magenta = {5, '#cc7ab1' },
  magentaLight = {13, '#eba0d2' },
  cyan = {6, '#6eb89f' },
  cyanLight = {14, '#92d6bf' },
  grey = {7, '#9aaab8' },
  greyLight = {15, '#d8e2eb' },
}

-- ---------------------------------------------------------------------------
-- Definitions
-- ---------------------------------------------------------------------------
-- Definitions can be string values, which indicates a highlight link
-- or tables with the following keys:
--
-- bg     = background color
-- fg     = foreground color
-- attrs  = a list of attributes (bold, italic, etc.)
local definitions = {
  -- Reusable groups
  TextBg = { fg = palette.bg },
  TextFg = { fg = palette.fg },
  TextBlack = { fg = palette.black },
  TextBlackLight = { fg = palette.blackLight },
  TextRed = { fg = palette.red },
  TextRedLight = { fg = palette.redLight },
  TextGreen = { fg = palette.green },
  TextGreenLight = { fg = palette.greenLight },
  TextYellow = { fg = palette.yellow },
  TextYellowLight = { fg = palette.yellowLight },
  TextBlue = { fg = palette.blue },
  TextBlueLight = { fg = palette.blueLight },
  TextMagenta = { fg = palette.magenta },
  TextMagentaLight = { fg = palette.magentaLight },
  TextCyan = { fg = palette.cyan },
  TextCyanLight = { fg = palette.cyanLight },
  TextGrey = { fg = palette.grey },
  TextGreyLight = { fg = palette.greyLight },

  -- Editing area
  -- -------------------------------------------------------------------------
  -- Cursor
  Cursor = { fg = palette.fg, bg = palette.black, attrs = {'reverse'} },
  iCursor = 'Cursor',
  lCursor = 'Cursor',
  vCursor = 'Cursor',
  MatchParen = { bg = palette.black },

  -- Selection
  Visual = { bg = palette.black, fg = palette.fg },
  VisualNOS = 'Visual',

  -- UI
  -- -------------------------------------------------------------------------
  -- Errors, warnings, info, etc.
  Error = { fg = palette.red, attrs = {'bold', 'reverse'} },
  Info = { fg = palette.blue, attrs = {'reverse'} },
  Warning = { fg = palette.yellow, attrs = {'reverse'} },
  ErrorMsg = { bg = palette.red },
  ModeMsg = { fg = palette.blue, attrs = {'bold'} },
  MoreMsg = { fg = palette.yellow, attrs = {'bold'} },
  WarningMsg = { fg = palette.red, attrs = {'bold'} },
  Question = { fg = palette.redLight, attrs = {'bold'} },
  Title = { fg = palette.green, attrs = {'bold'} },

  -- Menus
  Pmenu = { bg = palette.black },
  PmenuSel = { fg = palette.blue, attrs = {'reverse'} },
  PmenuSbar = { fg = palette.grey },
  PmenuThumb = { fg = palette.greenLight },
  QuickFixLine = { fg = palette.blue, attrs = {'reverse'} },
  WildMenu = 'PmenuSel',

  -- Floating windows
  NormalFloat = { bg = 'none' },

  -- Statusline
  StatusLine = 'StatusLineBackground',
  StatusLineNC = 'StatusLineGrey',
  StatusLineTerm = 'StatusLine',
  StatusLineTermNC = 'StatusLineNC',
  -- Custom statusline extensions so you can link them up to User highlights
  StatusLineBackground = { bg = palette.black },
  StatusLineBlue = { fg = palette.blue, bg = palette.black },
  StatusLineBlueLight = { fg = palette.blueLight, bg = palette.black, attrs = {'bold'} },
  StatusLineCyan = { fg = palette.cyan, bg = palette.black },
  StatusLineGreen = { fg = palette.green, bg = palette.black },
  StatusLineGrey = { fg = palette.grey, bg = palette.black },
  StatusLineRed = { fg = palette.red, bg = palette.black, attrs = {'bold'} },
  StatusLineYellow = { fg = palette.yellow, bg = palette.black, attrs = {'bold'} },

  -- Tabline
  TabLine = { fg = palette.blueLight },
  TabLineFill = { fg = palette.black, attrs = {'underline'} },
  TabLineSel = { fg = palette.blueLight, attrs = {'bold', 'reverse' } },

  -- Window dressing & UI
  ColorColumn = { bg = palette.black },
  Conceal = 'TextBlue',
  SpecialKey = 'TextBlackLight',
  NonText = 'TextBlack',
  CursorColumn = 'ColorColumn',
  CursorLine = 'CursorColumn',
  CursorLineNr = 'TextGrey',
  Folded = 'TextBlackLight',
  FoldColumn = 'Folded',
  LineNr = 'TextBlackLight',
  LineNrAbove = 'LineNr',
  LineNrBelow = 'LineNr',
  SignColumn = 'TextBlack',
  WinSeparator = 'TextBlack',

  -- Search
  CurSearch = { fg = palette.yellowLight, attrs = {'reverse'} },
  IncSearch = 'CurSearch',
  Search = { fg = palette.yellow, attrs = {'reverse'} },
  Substitute = 'Search',

  -- Syntax
  -- -------------------------------------------------------------------------
  -- Diffs
  DiffAdd = 'TextGreen',
  DiffChange = 'TextBlue',
  DiffDelete = 'TextRed',
  -- TODO: check this.
  DiffText = { fg = palette.blueLight, attrs = {'reverse'} },
  diffAdded = 'TextGreen',
  diffFile = 'TextYellowLight',
  diffIndexLine = 'TextYellowLight',
  diffLine = 'TextMagentaLight',
  diffRemoved = 'TextRed',
  diffSubname = 'Normal',

  -- Spelling
  SpellBad = { attrs = {'undercurl'}, sp = palette.red },
  SpellCap = { attrs = {'undercurl'}, sp = palette.yellow },
  SpellLocal = { attrs = {'undercurl'}, sp = palette.cyan },
  SpellRare = { attrs = {'undercurl'}, sp = palette.magenta },

  -- Code
  Boolean = 'TextMagenta',
  Character = 'TextRedLight',
  Conditional = 'TextRed',
  Constant = 'TextGreyLight',
  Debug = 'TextGreenLight',
  Define = 'TextCyan',
  Delimiter = 'TextGrey',
  Directory = 'TextBlue',
  Exception = 'TextRedLight',
  Float = 'TextMagentaLight',
  Function = 'TextYellow',
  Identifier = 'TextFg',
  Ignore = { fg = palette.black },
  Include = 'TextRedLight',
  Keyword = 'TextRed',
  Label = 'TextRed',
  Macro = 'TextCyan',
  Number = 'TextMagentaLight',
  Operator = 'TextGreyLight',
  PreCondit = 'TextCyanLight',
  PreProc = 'TextCyan',
  Repeat = 'TextRedLight',
  Special = 'TextRedLight',
  SpecialChar = 'TextGreenLight',
  Statement = 'TextRed',
  StorageClass = 'TextBlueLight',
  String = 'TextGreen',
  Structure = 'TextCyan',
  Type = 'TextBlue',
  Typedef = 'TextBlue',
  Underlined = { attrs = {'underline'} },

  -- Comments
  Comment = { fg = palette.blackLight, attrs = {'italic'} },
  SpecialComment = { fg = palette.fg, attrs = {'bold', 'italic'} },
  Todo = { fg = palette.fg, attrs = {'bold', 'italic' } },

  -- LSP
  DiagnosticError = 'TextRed',
  DiagnosticSignError = { fg = palette.red, attrs = {'bold' } },
  DiagnosticUnderlineError = { attrs = {'undercurl'}, sp = palette.red },
  DiagnosticWarn = 'TextYellow',
  DiagnosticSignWarn = { fg = palette.yellow, attrs = {'bold'} },
  DiagnosticUnderlineWarn = { attrs = {'undercurl'}, sp = palette.yellow },
  DiagnosticInfo = 'TextBlue',
  DiagnosticSignInfo = { fg = palette.blue, attrs = {'bold'} },
  DiagnosticUnderlineInfo = { attrs = {'undercurl'}, sp = palette.blue },
  DiagnosticHint = 'TextCyan',
  DiagnosticSignHint = { fg = palette.cyan, attrs = {'bold'} },
  DiagnosticUnderlineHint = { attrs = {'undercurl'}, sp = palette.cyan },
  DiagnosticFloatingError = 'TextRed',
  DiagnosticFloatingWarn = 'TextYellow',
  DiagnosticFloatingInfo = 'TextBlue',
  DiagnosticFloatingHint = 'TextCyan',
  DiagnosticVirtualTextError = 'TextRed',
  DiagnosticVirtualTextWarn = 'TextYellow',
  DiagnosticVirtualTextInfo = 'TextBlue',
  DiagnosticVirtualTextHint = 'TextCyan',
  -- wtf are these
  LspReferenceRead = { fg = palette.yellow, attrs = {'bold'} },
  LspReferenceText = { fg = palette.yellow, attrs = {'bold'} },
  LspReferenceWrite = { fg = palette.redLight, attrs = {'bold'} },
  LspCodeLens = 'TextGrey',
  LspSignatureActiveParameter = 'CurSearch',

  -- Treesitter
  -- -------------------------------------------------------------------------
  -- Misc
  -- ['@comment'] = 'Comment',
  -- ['@comment.documentation'] = '',
  ['@comment.note'] = 'Todo',
  ['@comment.todo'] = 'Todo',
  ['@comment.warning'] = { fg = palette.yellow, attrs = {'bold'} },
  ['@error'] = 'Error',
  ['@none'] = { fg = 'none', bg = 'none' },
  -- ['@preproc'] = 'PreProc',
  -- ['@define'] = 'Define',
  -- ['@macro'] = 'Macro',
  -- ['@operator'] = 'Operator',

  -- Punctuation
  -- ['@punctuation.delimiter'] = 'Delimiter',
  -- ['@punctuation.bracket'] = 'Delimiter',
  -- ['@punctuation.special'] = 'Delimiter',

  -- Literals
  -- ['@string'] = 'String',
  -- ['@string.documentation'] = '',
  ['@string.regex'] = 'String',
  -- ['@string.escape'] = 'SpecialChar',
  -- ['@string.special'] = 'SpecialChar',
  -- ['@character'] = 'Character',
  -- ['@character.special'] = 'SpecialChar',
  -- ['@number'] = 'Number',
  -- ['@boolean'] = 'Boolean',
  -- ['@float'] = 'Float',

  -- Functions
  -- ['@function'] = 'Function',
  -- ['@function.builtin'] = 'Special',
  -- ['@function.call'] = 'Function',
  -- ['@function.macro'] = 'Macro',
  -- ['@method'] = 'TextYellowLight',
  -- ['@method.call'] = 'Function',
  -- ['@constructor'] = 'Special',
  ['@parameter'] = 'TextYellowLight',

  -- Keywords
  -- ['@keyword'] = 'Keyword',
  -- ['@keyword.coroutine'] = 'Keyword',
  ['@keyword.exception'] = 'Include',
  ['@keyword.function'] = 'Keyword',
  ['@keyword.import'] = 'Include',
  ['@keyword.operator'] = 'Operator',
  ['@keyword.return'] = 'Statement',
  -- ['@conditional'] = 'Conditional',
  -- ['@conditional.ternary'] = '',
  -- ['@repeat'] = 'Repeat',
  -- ['@debug'] = 'Debug',
  -- ['@label'] = 'Label',
  -- ['@include'] = 'Include',
  -- ['@exception'] = 'Exception',

  -- Markup
  ['@markup.heading'] = 'Title',
  ['@markup.italic'] = { attrs = {'italic'} },
  ['@markup.link'] = 'Delimiter',
  ['@markup.link.label'] = 'TextBlue',
  ['@markup.link.url'] = 'TextYellowLight',
  ['@markup.quote'] = 'TextCyanLight',
  ['@markup.raw'] = 'SpecialKey',
  ['@markup.strong'] = { attrs = {'bold'} },

  -- Types
  -- ['@type'] = 'Type',
  ['@type.builtin'] = 'TextBlueLight',
  -- ['@type.definition'] = 'TypeDef',
  ['@type.qualifier'] = 'TextCyanLight',
  -- ['@storageclass'] = 'StorageClass',
  ['@attribute'] = 'PeProc',
  -- ['@field'] = 'Identifier',
  ['@property'] = 'TextCyan',
  -- ['@structure'} = 'Structure',

  -- Identifiers
  -- ['@variable'] = 'Identifier',
  ['@variable.builtin'] = 'TextCyanLight',
  ['@variable.member'] = 'TextCyan',
  ['@variable.parameter'] = 'TextYellowLight',
  -- ['@constant'] = 'Constant',
  -- ['@constant.builtin'] = 'Special',
  -- ['@constant.macro'] = 'Define',
  -- ['@namespace'] = 'Identifier',
  ['@symbol'] = 'Identifier',

  -- Text
  ['@text'] = 'TextFg',
  ['@text.strong'] = { attrs = {'bold'} },
  ['@text.emphasis'] = { attrs = {'italic'} },
  -- ['@text.underline'] = { attrs = {'underline'} },
  ['@text.strike'] = { attrs = {'strikethrough'} },
  -- ['@text.title'] = 'Title',
  -- ['@text.quote'] = '',
  -- ['@text.uri'] = 'Underlined',
  ['@text.math'] = 'Special',
  ['@text.environment'] = 'Macro',
  ['@text.environment.name'] = 'Type',
  ['@text.reference'] = 'Constant',
  ['@text.literal'] = 'String',
  -- ['@text.literal.block'] = '',
  -- ['@text.todo'] = 'Todo',
  ['@text.note'] = 'SpecialComment',
  ['@text.warning'] = 'SpecialComment',
  ['@text.danger'] = 'SpecialComment',
  ['@text.diff.add'] = 'DiffAdd',
  ['@text.diff.delete'] = 'DiffDelete',

  -- Tags
  ['@tag'] = 'Function',
  ['@tag.attribute'] = '@property',
  ['@tag.delimiter'] = 'Delimiter',

  -- LSP
  -- -------------------------------------------------------------------------
  -- ['@lsp.type.class'] = 'Structure',
  -- ['@lsp.type.decorator'] = 'Function',
  -- ['@lsp.type.enum'] = 'Structure',
  -- ['@lsp.type.enumMember'] = 'Constant',
  -- ['@lsp.type.function'] = 'Function',
  -- ['@lsp.type.interface'] = 'Structure',
  -- ['@lsp.type.macro'] = 'Macro',
  -- ['@lsp.type.method'] = 'Function',
  -- ['@lsp.type.namespace'] = 'Structure',
  -- ['@lsp.type.parameter'] = '@parameter',
  -- ['@lsp.type.property'] = '@property',
  -- ['@lsp.mod.defaultLibrary'] = '@variable.builtin',
  -- ['@lsp.type.struct'] = 'Structure',
  -- ['@lsp.type.type'] = 'Type',
  -- ['@lsp.type.typeParameter'] =' ',
  -- ['@lsp.type.variable'] = 'Identifier',


  -- ALE
  -- -------------------------------------------------------------------------
  ALEError = 'DiagnosticUnderlineError',
  ALEInfo = 'DiagnosticUnderlineInfo',
  ALEWarning = 'DiagnosticUnderlineWarn',
  ALEErrorSign = 'DiagnosticSignError',
  ALEWarningSign = 'DiagnosticSignWarn',
  ALEInfoSign = 'DiagnosticSignInfo',

  -- fugitive
  -- -------------------------------------------------------------------------
  fugitiveStagedHeading = 'TextGreen',
  fugitiveStagedModifier = 'TextGreen',
  fugitiveUnstagedHeading = 'TextYellow',
  fugitiveUnstagedModifier = 'TextYellow',
  fugitiveUntrackedHeading = 'TextMagenta',
  fugitiveUntrackedModifier = 'TextMagenta',

  -- fzf-lua
  -- -------------------------------------------------------------------------
  FzfLuaBorder = 'FloatBorder',

  -- gitsigns
  -- -------------------------------------------------------------------------
  GitSignsAdd = 'TextGreen',
  GitSignsChange = 'TextYellow',
  GitSignsDelete = 'TextRed',
  GitSignsUntracked = 'TextMagenta',

  -- netrw
  -- -------------------------------------------------------------------------
  netrwExe = 'Function',
  netrwLink = 'Underline',
  netrwSymLink = 'netrwLink',
  netrwTreeBar = 'Delimiter',
}

-- ---------------------------------------------------------------------------
-- Theme lift off
-- ---------------------------------------------------------------------------
vim.cmd.hi('clear')

for _, group in ipairs(vim.fn.getcompletion('@lsp', 'highlight')) do
  vim.api.nvim_set_hl(0, group, {})
end

for name, definition in pairs(definitions) do
  vim.api.nvim_set_hl(0, name, get_group(definition))
end
