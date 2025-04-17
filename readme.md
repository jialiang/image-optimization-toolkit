# Image Optimization Toolkit

Generates AVIF, WEBP and JXL from PNG or JPG and shows you the SSIMULACRA 2 score so that you can balance size and quality

A score of >= 90 means the output is visually lossless.

## Usage

1. Run `iot <avif|webp|jxl> <lossless|0|100> [example.png|jpg]`.
2. Example output:
   - Console shows: `"example.avif" with quality 90 and size 1KB has score 91.163.`
   - File `example.avif` is generated.

## Notes

- If no filename is provided, the script will assume the first PNG/JPG image it finds in the current directory.
- The latest conversion of each format is placed in the root folder. All conversions are stored in the History folder with filenames that indicate their quality and score, e.g. `example_(Q=90)(S=91.163).avif`.

## Binaries

You should update the binaries to the latest version from time to time. You can either:

- Delete the provided binaries and use a package manager like Chocolatey, Scoop or WinGet, or
- Download and replace the binaries manually from:

  - [LibAVIF Releases](https://github.com/AOMediaCodec/libavif/releases): avifenc.exe, avifdec.exe
  - [WebP Downloads Repository](https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html): cwebp.exe, dwebp.exe
  - [LibJXL Releases](https://github.com/libjxl/libjxl/releases): cjxl.exe, djxl.exe

  [SSIMULACRA2](https://github.com/cloudinary/ssimulacra2) doesn't provide any precompiled binary so you'll have to build it yourself, but they haven't updated since mid-2023 so you should be good.
