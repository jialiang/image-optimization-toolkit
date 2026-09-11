# Image Optimization Toolkit

**iot.bat:** Generates AVIF, WEBP, JXL and JPG from PNG or JPG and shows you the SSIMULACRA 2 score so that you can balance size and quality. A score of ≥ 90 means the output is visually lossless.

**opng.bat:** Optimizes PNG images in-place using Oxipng and ECT.

Only works on x64 Windows.

## Install

Ideally you would clone this repository with Git.

Alternatively you can [download this repository as a ZIP file](https://github.com/jialiang/image-optimization-toolkit/archive/refs/heads/master.zip).

## Usage

Add the folder of `iot.bat` or `opng.bat` to your PATH environment variable to use the `iot` and `opng` commands from anywhere.

### iot.bat

Run `iot <avif|webp|jxl|jpg> <lossless|0-100> [example.png|jpg]` in the command line.

If no filename is provided, the script will assume the first PNG or JPG image it finds in the working folder.

JPEG has no lossless mode, so `jpg` only accepts a quality from 1 to 100. It also refuses a JPG input, because the output would overwrite it.

Example:

- **Input:** `iot avif 90 example.png`
- **Output:**
  - Console shows: `"example.avif" with quality 90 and size 1KB has score 91.163.`
  - Within the working folder:
    - Image `example.avif` is created
    - A copy `example_(Q=90)(S=91.163).avif` is stored in the **history** folder.

### opng.bat

Run `opng [path/to/file/or/folder]` in the command line.

If no argument is provided, it sets the current folder as the target.

If the target is a folder, it will recursively optimize every PNG image in-place; if the target is a PNG image, it will only optimize that specific image.

Current configuration might not result in the smallest possible sizes because pushing further means waiting minutes just to save a few bytes.

Animation chunks for APNG and ICC profiles are preserved. Fully transparent pixels have their color values zeroed.

## Binaries

Binaries in folders defined in your PATH environment variable takes precedence over those in the **encoders** folder.

You should update the binaries from time to time. You can either use a package manager like Chocolatey, Scoop or WinGet, or download and replace the binaries in the **encoders** folder manually from:

- [LibAVIF Releases](https://github.com/AOMediaCodec/libavif/releases) for `avifenc.exe` and `avifdec.exe`.
- [WebP Downloads Repository](https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html) for `cwebp.exe` and `dwebp.exe`.
- [LibJXL Releases](https://github.com/libjxl/libjxl/releases) for `cjxl.exe` and `djxl.exe`.
- [LibJXL v0.11.1](https://github.com/libjxl/libjxl/releases/tag/v0.11.1) for `cjpegli.exe`, the last LibJXL release to bundle it.
- [Oxipng Releases](https://github.com/oxipng/oxipng/releases) for `oxipng.exe`.
- [ECT Releases](https://github.com/fhanau/Efficient-Compression-Tool/releases) for `ect.exe`.

[Jpegli](https://github.com/google/jpegli) and [SSIMULACRA2](https://github.com/cloudinary/ssimulacra2) don't provide any precompiled binary so you'll have to build them yourself, but jpegli's encoder output hasn't changed since and SSIMULACRA2 hasn't updated since mid-2023 so you should be good.

Versions of binaries included in repo:

- LibAVIF: v1.4.2
- WebP: v1.6.0
- LibJXL: v0.12.0
- Jpegli: v0.11.1
- Oxipng: v10.2.1
- ECT: v0.9.5
