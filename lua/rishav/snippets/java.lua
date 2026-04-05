---@module "rishav.snippets.java"
---Custom Java snippets for LuaSnip
local M = {}

function M.setup()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local c = ls.choice_node
    local f = ls.function_node
    local fmt = require("luasnip.extras.fmt").fmt

    local java_snippets = {
        -- Public function with return type and parameters
        s(
            { trig = "pf", desc = "Public function" },
            fmt(
                [[
public {} {}({}) {{
    {}
}}
]],
                {
                    i(1, "void"),
                    i(2, "methodName"),
                    i(3, ""),
                    i(4, "// TODO: implement"),
                }
            )
        ),

        -- Private function with return type and parameters
        s(
            { trig = "prf", desc = "Private function" },
            fmt(
                [[
private {} {}({}) {{
    {}
}}
]],
                {
                    i(1, "void"),
                    i(2, "methodName"),
                    i(3, ""),
                    i(4, "// TODO: implement"),
                }
            )
        ),

        -- Private static function with return type and parameters
        s(
            { trig = "prf", desc = "Private function" },
            fmt(
                [[
private static {} {}({}) {{
    {}
}}
]],
                {
                    i(1, "void"),
                    i(2, "methodName"),
                    i(3, ""),
                    i(4, "// TODO: implement"),
                }
            )
        ),
        -- Protected function
        s(
            { trig = "prof", desc = "Protected function" },
            fmt(
                [[
protected {} {}({}) {{
    {}
}}
]],
                {
                    i(1, "void"),
                    i(2, "methodName"),
                    i(3, ""),
                    i(4, "// TODO: implement"),
                }
            )
        ),

        -- Static function
        s(
            { trig = "sf", desc = "Static function" },
            fmt(
                [[
public static {} {}({}) {{
    {}
}}
]],
                {
                    i(1, "void"),
                    i(2, "methodName"),
                    i(3, ""),
                    i(4, "// TODO: implement"),
                }
            )
        ),

        -- HashMap declaration
        s(
            { trig = "map", desc = "HashMap declaration" },
            fmt(
                [[
Map<{}, {}> {} = new HashMap<>();
]],
                {
                    i(1, "KeyType"),
                    i(2, "ValueType"),
                    i(3, "map"),
                }
            )
        ),

        -- HashSet declaration
        s(
            { trig = "set", desc = "HashSet declaration" },
            fmt(
                [[
Set<{}> {} = new HashSet<>();
]],
                {
                    i(1, "Type"),
                    i(2, "set"),
                }
            )
        ),

        -- ArrayList declaration
        s(
            { trig = "list", desc = "ArrayList declaration" },
            fmt(
                [[
List<{}> {} = new ArrayList<>();
]],
                {
                    i(1, "Type"),
                    i(2, "list"),
                }
            )
        ),

        -- LinkedList declaration
        s(
            { trig = "llist", desc = "LinkedList declaration" },
            fmt(
                [[
List<{}> {} = new LinkedList<>();
]],
                {
                    i(1, "Type"),
                    i(2, "list"),
                }
            )
        ),

        -- For loop decrementing
        s(
            { trig = "fori-", desc = "For loop (decrementing)" },
            fmt(
                [[
for (int i = {}; i > 0; i--) {{
    {}
}}
]],
                {
                    i(1, "n"),
                    i(2, "// TODO"),
                }
            )
        ),

        -- For loop incrementing
        s(
            { trig = "fori", desc = "For loop (incrementing)" },
            fmt(
                [[
for (int i = 0; i < {}; i++) {{
    {}
}}
]],
                {
                    i(1, "n"),
                    i(2, "// TODO"),
                }
            )
        ),

        -- For each loop
        s(
            { trig = "fore", desc = "For each loop" },
            fmt(
                [[
for ({} {} : {}) {{
    {}
}}
]],
                {
                    i(1, "Type"),
                    i(2, "item"),
                    i(3, "collection"),
                    i(4, "// TODO"),
                }
            )
        ),

        -- Array length variable
        s(
            { trig = "n", desc = "Array length variable" },
            fmt(
                [[
int {} = {}.length;
]],
                {
                    i(1, "n"),
                    i(2, "arr"),
                }
            )
        ),

        -- List size variable
        s(
            { trig = "nsize", desc = "List size variable" },
            fmt(
                [[
int {} = {}.size();
]],
                {
                    i(1, "n"),
                    i(2, "list"),
                }
            )
        ),

        -- Main method
        s(
            { trig = "main", desc = "Main method" },
            fmt(
                [[
public static void main(String[] args) {{
    {}
}}
]],
                {
                    i(1, "// TODO"),
                }
            )
        ),

        -- System.out.println
        s(
            { trig = "sout", desc = "System.out.println" },
            fmt(
                [[
System.out.println({});
]],
                {
                    i(1, ""),
                }
            )
        ),

        -- System.out.print
        s(
            { trig = "soutp", desc = "System.out.print" },
            fmt(
                [[
System.out.print({});
]],
                {
                    i(1, ""),
                }
            )
        ),

        -- System.out.printf
        s(
            { trig = "soutf", desc = "System.out.printf" },
            fmt(
                [[
System.out.printf("{}", {});
]],
                {
                    i(1, "%s"),
                    i(2, ""),
                }
            )
        ),

        -- Try-catch block
        s(
            { trig = "try", desc = "Try-catch block" },
            fmt(
                [[
try {{
    {}
}} catch ({} e) {{
    e.printStackTrace();
}}
]],
                {
                    i(1, "// TODO"),
                    i(2, "Exception"),
                }
            )
        ),

        -- Try-catch-finally block
        s(
            { trig = "tryf", desc = "Try-catch-finally block" },
            fmt(
                [[
try {{
    {}
}} catch ({} e) {{
    e.printStackTrace();
}} finally {{
    {}
}}
]],
                {
                    i(1, "// TODO"),
                    i(2, "Exception"),
                    i(3, "// cleanup"),
                }
            )
        ),

        -- If statement
        s(
            { trig = "if", desc = "If statement" },
            fmt(
                [[
if ({}) {{
    {}
}}
]],
                {
                    i(1, "condition"),
                    i(2, "// TODO"),
                }
            )
        ),

        -- If-else statement
        s(
            { trig = "ife", desc = "If-else statement" },
            fmt(
                [[
if ({}) {{
    {}
}} else {{
    {}
}}
]],
                {
                    i(1, "condition"),
                    i(2, "// TODO"),
                    i(3, "// TODO"),
                }
            )
        ),

        -- While loop
        s(
            { trig = "while", desc = "While loop" },
            fmt(
                [[
while ({}) {{
    {}
}}
]],
                {
                    i(1, "condition"),
                    i(2, "// TODO"),
                }
            )
        ),

        -- Do-while loop
        s(
            { trig = "dowhile", desc = "Do-while loop" },
            fmt(
                [[
do {{
    {}
}} while ({});
]],
                {
                    i(1, "// TODO"),
                    i(2, "condition"),
                }
            )
        ),

        -- Switch statement
        s(
            { trig = "switch", desc = "Switch statement" },
            fmt(
                [[
switch ({}) {{
    case {}:
        {}
        break;
    default:
        {}
        break;
}}
]],
                {
                    i(1, "variable"),
                    i(2, "value"),
                    i(3, "// TODO"),
                    i(4, "// TODO"),
                }
            )
        ),

        -- Class declaration
        s(
            { trig = "class", desc = "Class declaration" },
            fmt(
                [[
public class {} {{
    {}
}}
]],
                {
                    i(1, "ClassName"),
                    i(2, "// TODO"),
                }
            )
        ),

        -- Constructor
        s(
            { trig = "ctor", desc = "Constructor" },
            fmt(
                [[
public {}({}) {{
    {}
}}
]],
                {
                    f(function()
                        local filename = vim.fn.expand("%:t:r")
                        return filename
                    end),
                    i(1, ""),
                    i(2, "// TODO"),
                }
            )
        ),

        -- Getter method
        s(
            { trig = "get", desc = "Getter method" },
            fmt(
                [[
public {} get{}() {{
    return {};
}}
]],
                {
                    i(1, "Type"),
                    i(2, "PropertyName"),
                    i(3, "field"),
                }
            )
        ),

        -- Setter method
        s(
            { trig = "set", desc = "Setter method" },
            fmt(
                [[
public void set{}({} {}) {{
    this.{} = {};
}}
]],
                {
                    i(1, "PropertyName"),
                    i(2, "Type"),
                    i(3, "value"),
                    i(4, "field"),
                    i(5, "value"),
                }
            )
        ),

        -- Private field
        s(
            { trig = "field", desc = "Private field" },
            fmt(
                [[
private {} {};
]],
                {
                    i(1, "Type"),
                    i(2, "fieldName"),
                }
            )
        ),

        -- Javadoc comment
        s(
            { trig = "doc", desc = "Javadoc comment" },
            fmt(
                [[
/**
 * {}
 * @param {} {}
 * @return {}
 */
]],
                {
                    i(1, "Description"),
                    i(2, "param"),
                    i(3, "description"),
                    i(4, "description"),
                }
            )
        ),

        -- TODO comment
        s({ trig = "todo", desc = "TODO comment" }, t("// TODO: ")),

        -- FIXME comment
        s({ trig = "fixme", desc = "FIXME comment" }, t("// FIXME: ")),

        -- Return statement
        s(
            { trig = "ret", desc = "Return statement" },
            fmt(
                [[
return {};
]],
                {
                    i(1, "value"),
                }
            )
        ),

        -- Return true
        s({ trig = "rettrue", desc = "Return true" }, t("return true;")),

        -- Return false
        s({ trig = "retfalse", desc = "Return false" }, t("return false;")),

        -- Return null
        s({ trig = "retnull", desc = "Return null" }, t("return null;")),

        -- New instance
        s(
            { trig = "new", desc = "New instance" },
            fmt(
                [[
{} {} = new {}({});
]],
                {
                    i(1, "Type"),
                    i(2, "variable"),
                    f(function(args)
                        return args[1][1]
                    end, { 1 }),
                    i(3, ""),
                }
            )
        ),

        -- String declaration
        s(
            { trig = "str", desc = "String declaration" },
            fmt(
                [[
String {} = "{}";
]],
                {
                    i(1, "str"),
                    i(2, ""),
                }
            )
        ),

        -- Integer declaration
        s(
            { trig = "int", desc = "int declaration" },
            fmt(
                [[
int {} = {};
]],
                {
                    i(1, "n"),
                    i(2, "0"),
                }
            )
        ),

        -- Boolean declaration
        s(
            { trig = "bool", desc = "boolean declaration" },
            fmt(
                [[
boolean {} = {};
]],
                {
                    i(1, "flag"),
                    c(2, {
                        t("true"),
                        t("false"),
                    }),
                }
            )
        ),

        -- Override annotation
        s({ trig = "override", desc = "@Override annotation" }, t("@Override")),

        -- Stream API
        s(
            { trig = "stream", desc = "Stream API" },
            fmt(
                [[
{}.stream()
    .{}({})
    .collect(Collectors.toList());
]],
                {
                    i(1, "collection"),
                    i(2, "filter"),
                    i(3, "x -> x"),
                }
            )
        ),

        -- Lambda expression
        s(
            { trig = "lambda", desc = "Lambda expression" },
            fmt(
                [[
({}) -> {}
]],
                {
                    i(1, "x"),
                    i(2, "x"),
                }
            )
        ),

        -- Optional
        s(
            { trig = "opt", desc = "Optional" },
            fmt(
                [[
Optional<{}> {} = Optional.ofNullable({});
]],
                {
                    i(1, "Type"),
                    i(2, "optional"),
                    i(3, "value"),
                }
            )
        ),

        -- Logger
        s(
            { trig = "log", desc = "Logger declaration" },
            fmt(
                [[
private static final Logger logger = LoggerFactory.getLogger({}.class);
]],
                {
                    f(function()
                        local filename = vim.fn.expand("%:t:r")
                        return filename
                    end),
                }
            )
        ),
    }

    -- Add snippets for Java filetype
    ls.add_snippets("java", java_snippets)
end

return M
