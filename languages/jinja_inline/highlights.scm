; String literals
(string_literal) @string

; Numeric literals
(number_literal) @number
(float_literal) @number.float

; Boolean literals
(boolean_literal) @boolean

; Null literal
(null_literal) @constant.builtin

; Comments
(comment) @comment

; Identifiers (variable references)
(identifier) @variable

; Function calls
(function_call
  (identifier) @function.call)

; Function arguments
(arg
  (identifier) @variable.parameter)

(arg
  (expression
    (binary_expression
      (unary_expression
        (primary_expression
          (identifier) @variable.parameter)))))

; Attribute / member access: foo.bar
(primary_expression
  "."
  (identifier) @variable.member)

(assignment_expression
  "."
  (identifier)+ @variable.member)

; Filters: variable | filter_name
(binary_expression
  (binary_operator) @_op
  (unary_expression
    (primary_expression
      (identifier) @function.call))
  (#eq? @_op "|"))

; Control flow keywords
[
  "if"
  "elif"
  "else"
  (endif_statement)
] @keyword.conditional

[
  "for"
  "in"
  (endfor_statement)
  "continue"
  "break"
] @keyword.repeat

; Block/structure keywords
[
  "block"
  (endblock_statement)
  "macro"
  (endmacro_statement)
  "call"
  (endcall_statement)
  "filter"
  (endfilter_statement)
  "set"
  (endset_statement)
  "with"
  (endwith_statement)
  "trans"
  (endtrans_statement)
  "pluralize"
  "autoescape"
  (endautoescape_statement)
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

; Inline translation helper
(inline_trans
  "_" @function.builtin)

; Raw block content
(raw_end) @keyword
(raw_body) @markup.raw.block
