import 'package:flutter/material.dart';

class NewsNetworkImage extends StatelessWidget {
  const NewsNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: width,
        child: imageUrl.isEmpty
            ? _ImageFallback(height: height)
            : Image.network(
                imageUrl,
                fit: fit,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _ImageFallback(
                    height: height,
                    showLoader: true,
                  );
                },
                errorBuilder: (_, __, ___) => _ImageFallback(height: height),
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({
    required this.height,
    this.showLoader = false,
  });

  final double height;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: const Color(0xFF1A1F29),
      child: Center(
        child: showLoader
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.broken_image_outlined,
                size: 28,
                color: Color(0xFF5B6473),
              ),
      ),
    );
  }
}
