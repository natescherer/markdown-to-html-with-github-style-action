# Markdown to HTML with GitHub Style GitHub Action

A GitHub action to convert Markdown files to HTML via GitHub's API with embedded GitHub CSS style.

Essentially, this action will take input Markdown files and render them into self-contained HTML files that look as close as possible to how Markdown files are displayed on github.com.

It is tested and runs on `windows-latest`, `ubuntu-latest`, and `macos-latest`.

## Usage

```yaml
jobs:
  Job:
    runs-on: windows-latest
    steps:
      - name: Convert Markdown to HTML
        uses: natescherer/markdown-to-html-with-github-style-action@v1.0.0
        with:
          path: README.md,CHANGELOG.md,docs\doc1.md
          outputpath: out
```

### Inputs

This Action defines the following formal inputs.

| Name | Required | Description
|-|-|-|
| **`path`** | true | A comma-separated list of one or more paths to markdown files to convert, relative to the root of your project.
| **`outputpath`** | false | Path to a folder where HTML files should be saved. By default, HTML files will be saved in the same path as the source markdown file.
| **`matchpathstructure`** | false | If set to `true`, will output files into the path provided to `outputfolder` while preserving the directory structure of the input files. I.E. if `path` is `README.md,docs/Doc1.md` and `outputfolder` is `out`, the files created will be `out/README.html` and `out/docs/Doc1.html` rather than both files being created in the root of `out`.

### Outputs

This Action does not have outputs.

## Authors

**Nate Scherer** - *Initial work* - [natescherer](https://github.com/natescherer)

## License

This project is licensed under The MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgements

[sindresorhus](https://github.com/sindresorhus/github-markdown-css) - For creating the CSS used in this action
