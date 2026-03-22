; Delimiters: {{ }}, {%  %}, {# #} and trim variants
[
  "{{"
  "{{-"
  "{{+"
  "+}}"
  "-}}"
  "}}"
  "{%"
  "{%-"
  "{%+"
  "+%}"
  "-%}"
  "%}"
] @keyword.directive

; Comments
(comment) @comment

; String literals
(string_literal) @string

; Numeric literals
(number_literal) @number
(float_literal) @number.float

; Boolean literals
(boolean_literal) @boolean

; Null literal
(null_literal) @constant.builtin

; Identifiers (variable references)
(identifier) @variable

; Attribute / member access: foo.bar
(expression
  "."
  (expression)+ @variable.member)

(assignment_expression
  "."
  (identifier)+ @variable.member)

; Function calls
(function_call
  (identifier) @function.call)

; Control flow keywords
[
  "if"
  "elif"
  "else"
  "endif"
] @keyword.conditional

[
  "for"
  "in"
  "endfor"
  "continue"
  "break"
] @keyword.repeat

; Block/structure keywords
[
  "block"
  "endblock"
  "macro"
  "endmacro"
  "call"
  "endcall"
  "filter"
  "endfilter"
  "set"
  "endset"
  "with"
  "endwith"
  "trans"
  "endtrans"
  "pluralize"
  "autoescape"
  "endautoescape"
  "do"
  "debug"
  "required"
] @keyword

; Import keywords
[
  "include"
  "import"
  "from"
  "extends"
  "as"
] @keyword.import

; Filters: variable | filter_name (without arguments)
(binary_expression
  (binary_operator) @_op
  (unary_expression
    (primary_expression
      (identifier) @function.call))
  (#eq? @_op "|"))

; Operators
(binary_operator) @operator
[
  "not"
  "!"
] @operator

; Builtin tests (used with `is`)
(builtin_test
  [
    "boolean" "callable" "defined" "divisibleby"
    "eq" "escaped" "even" "filter" "float" "ge"
    "gt" "in" "integer" "iterable" "le" "lower"
    "lt" "mapping" "ne" "none" "number" "odd"
    "sameas" "sequence" "string" "test"
    "undefined" "upper"
  ] @keyword.operator)

; Attributes (with/without context, ignore missing)
[
  (attribute_ignore)
  (attribute_context)
  "recursive"
] @attribute.builtin

; Punctuation
[
  ","
  "."
  ":"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

; Raw block content
(raw_body) @markup.raw.block

; Inline translation helper
(inline_trans
  "_" @function.builtin)

