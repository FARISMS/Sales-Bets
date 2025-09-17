import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/live_stream.dart';
import '../providers/live_streams_provider.dart';
import 'chat_overlay_widget.dart';

class LiveStreamWidget extends StatefulWidget {
  final LiveStream stream;

  const LiveStreamWidget({super.key, required this.stream});

  @override
  State<LiveStreamWidget> createState() => _LiveStreamWidgetState();
}

class _LiveStreamWidgetState extends State<LiveStreamWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.stream.streamUrl),
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Auto-play for live streams
        if (widget.stream.isLive) {
          _controller!.play();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing video: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveStreamsProvider>(
      builder: (context, streamsProvider, child) {
        // Set current stream when widget builds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          streamsProvider.setCurrentStream(widget.stream.id);
        });

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Video Player
              _buildVideoPlayer(),

              // Stream Info Overlay
              _buildStreamInfoOverlay(),

              // Video Controls
              if (_showControls) _buildVideoControls(),

              // Chat Overlay
              if (streamsProvider.isChatVisible)
                Positioned(
                  right: 16,
                  top: 120,
                  bottom: 16,
                  child: ChatOverlayWidget(streamId: widget.stream.id),
                ),

              // Chat Toggle Button
              Positioned(
                right: 16,
                top: 80,
                child: _buildChatToggleButton(streamsProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized || _controller == null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Loading stream...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }

  Widget _buildStreamInfoOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and stream status
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.stream.isLive ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.stream.isLive) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          widget.stream.isLive ? 'LIVE' : 'SCHEDULED',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Stream title
              Text(
                widget.stream.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Team info and viewer count
              Row(
                children: [
                  Text(
                    widget.stream.teamLogo,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.stream.teamName,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatViewerCount(widget.stream.viewerCount),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    if (!_isInitialized || _controller == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            // Play/Pause button
            IconButton(
              onPressed: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              icon: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // Progress bar
            Expanded(
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white24,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Volume button
            IconButton(
              onPressed: () {
                // TODO: Implement volume control
              },
              icon: const Icon(Icons.volume_up, color: Colors.white),
            ),

            const SizedBox(width: 8),

            // Fullscreen button
            IconButton(
              onPressed: () {
                // TODO: Implement fullscreen
              },
              icon: const Icon(Icons.fullscreen, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatToggleButton(LiveStreamsProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () {
          provider.toggleChatVisibility();
        },
        icon: Icon(
          provider.isChatVisible ? Icons.chat : Icons.chat_bubble_outline,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatViewerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}
