# Image Optimization Toolkit

Generates AVIF, WEBP and JXL from PNG and shows you the SSIMULACRA 2 score so that you can balance size and quality

A score of >= 90 means the output is visually lossless.

## Usage

1. Place your PNG image in the root folder.
2. Run `index.bat {format} {quality}` where
   - `format` is one of `avif`, `webp` or `jxl`
   - `quality` is an integer from 0 to 100
3. A score is shown in the console and an image of your selected format is generated.

\*It will only process the first PNG it finds.

## Binaries

You should update the binaries to the latest version from time to time.

- You can either delete the binaries in the folder and use a package manager like Chocolatey, Scoop or WinGet, or
- Download and replace the binaries manually:
  - [LibAVIF Releases](https://github.com/AOMediaCodec/libavif/releases): avifenc.exe, avifdec.exe
  - [WebP Downloads Repository](https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html): cwebp.exe, dwebp.exe
  - [LibJXL releases](https://github.com/libjxl/libjxl/releases): cjxl.exe, djxl.exe
  - [SSIMULACRA2](https://github.com/cloudinary/ssimulacra2): You have to build it yourself, but they haven't updated since mid-2023 so you should be good.
