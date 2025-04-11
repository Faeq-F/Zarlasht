# Code Listing Creator

Allows you to produce a pdf with syntax highlighted Gleam code, which you can then use in your LaTeX documents with, for e.g., `\includegraphics{code.pdf}`.

An alternative to using a `lstlisting` with `lstdefinelanguage`

```sh
# Run the project
gleam run
# Render HTML docs locally (found at /build/dev/docs/code_listing_creator/)
gleam docs build
```
