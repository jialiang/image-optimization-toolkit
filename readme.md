# Image Optimization Toolkit

Generates AVIF, WEBP and JXL from PNG or JPG and shows you the SSIMULACRA 2 score so that you can balance size and quality

A score of >= 90 means the output is visually lossless.

## Usage

1. Run `index.bat <avif|webp|jxl> <lossless|0|100> [filename.png|jpg]`.
2. A score is shown in the console and an image of your selected format is generated.

If filename is not provided, it will assume the first PNG/JPG in the current directory.

## Binaries

You should update the binaries to the latest version from time to time.

- You can either delete the binaries in the folder and use a package manager like Chocolatey, Scoop or WinGet, or
- Download and replace the binaries manually:
  - [LibAVIF Releases](https://github.com/AOMediaCodec/libavif/releases): avifenc.exe, avifdec.exe
  - [WebP Downloads Repository](https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html): cwebp.exe, dwebp.exe
  - [LibJXL releases](https://github.com/libjxl/libjxl/releases): cjxl.exe, djxl.exe
  - [SSIMULACRA2](https://github.com/cloudinary/ssimulacra2): You have to build it yourself, but they haven't updated since mid-2023 so you should be good.
