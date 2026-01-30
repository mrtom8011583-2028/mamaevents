import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AdminImagePicker extends StatefulWidget {
  final String? initialUrl;
  final String storagePath; // Not used anymore but kept for API compatibility
  final Function(String url) onImageUploaded;

  const AdminImagePicker({
    super.key,
    this.initialUrl,
    required this.storagePath,
    required this.onImageUploaded,
  });

  @override
  State<AdminImagePicker> createState() => _AdminImagePickerState();
}

class _AdminImagePickerState extends State<AdminImagePicker> {
  Uint8List? _imageBytes;
  String? _encodedImage;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _encodedImage = widget.initialUrl;
  }

  Future<void> _pickAndProcessImage() async {
    try {
      // UPDATED: High Quality for Premium Experience
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,   // Full HD
        maxHeight: 1920,  // Full HD
        imageQuality: 95, // High quality
      );
      
      if (pickedFile != null) {
        setState(() {
          _isProcessing = true;
        });

        // Read bytes directly
        Uint8List bytes = await pickedFile.readAsBytes();
        
        // TARGET SIZE: Under 1.5MB (Increased from 100KB for quality)
        // If extremely large, we lightly compress, but maintain HD resolution
        if (bytes.lengthInBytes > 1500 * 1024) {
             try {
                // Iterative compression
                int quality = 85;
                while (bytes.lengthInBytes > 1500 * 1024 && quality > 50) {
                   final Uint8List? compressed = await FlutterImageCompress.compressWithList(
                      bytes,
                      minHeight: 1080, // Maintain at least 1080p
                      minWidth: 1080,  // Maintain at least 1080p
                      quality: quality,
                    );
                   if (compressed != null) {
                      bytes = compressed;
                   }
                   quality -= 10;
                }
             } catch (e) {
                // Fallback if compression fails (e.g. on web sometimes)
                debugPrint('Compression failed: $e');
             }
        }

        String base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

        setState(() {
          _imageBytes = bytes;
          _encodedImage = base64Image;
          _isProcessing = false;
        });

        // "Upload" is just passing the Base64 string back
        widget.onImageUploaded(base64Image);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selection failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    
    if (_imageBytes != null) {
      imageProvider = MemoryImage(_imageBytes!);
    } else if (_encodedImage != null && _encodedImage!.isNotEmpty) {
      if (_encodedImage!.startsWith('http')) {
        imageProvider = NetworkImage(_encodedImage!);
      } else if (_encodedImage!.startsWith('data:image')) {
         try {
           final base64String = _encodedImage!.split(',').last;
           imageProvider = MemoryImage(base64Decode(base64String));
         } catch(e) {
           // invalid base64
         }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cover Image',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isProcessing ? null : _pickAndProcessImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              image: imageProvider != null
                  ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                  : null,
            ),
            child: _isProcessing
                ? const Center(child: CircularProgressIndicator())
                : imageProvider == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to Select Image',
                            style: GoogleFonts.inter(color: Colors.grey[500]),
                          ),
                          Text(
                            '(Stored locally in DB)',
                            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[400]),
                          ),
                        ],
                      )
                    : null,
          ),
        ),
      ],
    );
  }
}
