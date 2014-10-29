This is the *first* editor.
------------------------------
Just plain **Markdown**, except that the input is sanitized:
<marquee>I'm the ghost from the past!</marquee>n
# Markdown Extra
## Tables
| Item             | Value |
| ---------------- | -----:|
| Air Conditioner  | $1600 |
| <del>Phone</del> |   $12 |
| *Pipe*           |    $1 |
I've added just some basic borders and padding. Notice that span-level tags will
still be rendered inside of the table. Also, you can specify a class for the generated
tables using `Markdown.Extra.init(converter, {table_class: "table table-striped"})` for instance.
## Fenced Code Blocks
```javascript
var foo = "bar";
```
You can also specify options. Markdown.Extra was given the following options
for this editor.
```javascript
  Markdown.Extra.init(converter1, {
    extensions: "all",
    highlighter: "prettify"
  });
```
