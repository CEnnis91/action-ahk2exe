# action-ahk2exe

Github action to compile AutoHotkey scripts into EXEs using [Ahk2Exe](https://www.autohotkey.com/docs/Scripts.htm#ahk2exe).

# Usage

See [action.yaml](action.yaml). Only supports Windows-based runners.

## Examples

### Basic
```yaml
runs-on: windows-latest
steps:
  - name: Compile with Ahk2Exe
    id: ahk2exe
    uses: cennis91/action-ahk2exe@v1
    with:
      in: src/example.ahk
```

### Complete
```yaml
jobs:
  example:
    name: Example
    runs-on: windows-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Compile with Ahk2Exe
        uses: cennis91/action-ahk2exe@v1
        id: ahk2exe
        with:
          in: src/example.ahk
          out: out/example.exe
          icon: res/icon.ico

      - name: Upload Artifact
        uses: actions/upload-artifact@v2
        with:
          name: compiled-binary
          path: ${{ steps.ahk2exe.outputs.binary }}
```

## Inputs

| Parameter  | Example              | Description |
| ---------- | -------------------- | ----------- |
| in         | src/example.ahk      | **Required.** The path and name of the script to compile. |
| out        | out/output.exe       | The path\name of the output .exe to be created. Default is the directory\base_name of the input file plus extension of .exe. |
| icon       | res/icon.ico         | The icon file to be used. |
| cp         | 65001                | Overrides the default codepage used to read script files. |
| base       | 'Unicode 32-bit.bin' | The base file to be used (a .bin file). |
| compress   | 1                    | Compress the exe? 0 = no, 1 = use MPRESS if present, 2 = use UPX if present. |
| resourceid | '#2'                 | Assigns a non-standard resource ID to be used for the main script for compilations which use an .exe base file. |

## Outputs

| Parameter  | Description |
| ---------- | ----------- |
| binary     | The compiled AutoHotkey binary |
| directory  | The base directory of the installed AutoHotkey |
| version    | The version of the installed AutoHotkey |

# Notes

This installs AutoHotkey via [scoop.sh](https://scoop.sh/). The install script can be found [here](https://github.com/lukesampson/scoop-extras/blob/master/bucket/autohotkey.json). Ahk2Exe is installed with AutoHotkey and the full source can be found [here](https://github.com/AutoHotkey/Ahk2Exe).

# License

License is [MIT](LICENSE.md).
