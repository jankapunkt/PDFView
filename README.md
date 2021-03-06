Note: For any issues, contact me via [info@jankuester.com](mailto:info@jankuester.com)

# PDFView
Actionscript 3 based PDF viewer, built from scratch using the Adobe PDF specification standard. Aims to provide a viewer without using additional packages or code from third parties.

### Licence Information
This project is released and maintained under the Apache 2.0 Licence.

### Current status

- loading page tree and pages
- loading resources
- read content streams
- decode cmap font encoding to unicode
- displaying texts
- displaying embedded JPEG images

### Installation Requirements

- Flex Sdk 4.6 or higher
- Flex IDE of your choice

If you are using apache flex sdk, you have to create a new branch and rewrite some base classes for compatibility, otherwise builds will generate errors. This is due to the aim, to provide backwards compatibility to Adobe Flex 4.6. A branch for Apache Flex Sdk will be set up soon.

### Troubleshooting

If your project works, but you get runtime errors, especially out of bound or end of file, try different PDF input files from the asset folder.

Currently working, but not perfect are lorem.pdf and lorem2.pdf
