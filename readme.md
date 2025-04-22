# Image Optimization Toolkit

Generates AVIF, WEBP and JXL from PNG or JPG and shows you the SSIMULACRA 2 score so that you can balance size and quality

A score of ≥ 90 means the output is visually lossless.

Only works on x64 Windows.

## Install

Ideally you would clone this repository with Git.

Alternatively you can [download this repository as a ZIP file](https://github.com/jialiang/image-optimization-toolkit/archive/refs/heads/master.zip).

## Usage

Run `iot <avif|webp|jxl> <lossless|0|100> [example.png|jpg]` in the command line.

If no filename is provided, the script will assume the first PNG or JPG image it finds in the working folder.

Example:

- **Input:** `iot avif 90 example.png`
- **Output:**
  - Console shows: `"example.avif" with quality 90 and size 1KB has score 91.163.`
  - Within the working folder:
    - Image `example.avif` is created
    - A copy `example_(Q=90)(S=91.163).avif` is stored in the **history** folder.

Add the folder of `iot.bat` to your PATH environment variable to use the `iot` command from anywhere.

## Binaries

Binaries in folders defined in your PATH environment variable takes precedence over those in the **encoders** folder.

You should update the binaries from time to time. You can either use a package manager like Chocolatey, Scoop or WinGet, or download and replace the binaries in the **encoders** folder manually from:

- [LibAVIF Releases](https://github.com/AOMediaCodec/libavif/releases) for `avifenc.exe` and `avifdec.exe`.
- [WebP Downloads Repository](https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html) for `cwebp.exe` and `dwebp.exe`.
- [LibJXL Releases](https://github.com/libjxl/libjxl/releases) for `cjxl.exe` and `djxl.exe`.

[SSIMULACRA2](https://github.com/cloudinary/ssimulacra2) doesn't provide any precompiled binary so you'll have to build it yourself, but they haven't updated since mid-2023 so you should be good.
