import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/brand.dart';
import '../../services/wintowin_state.dart';
import 'quiz_game_screen.dart';
import 'reaction_duel_screen.dart';

class MatchmakingScreen extends StatefulWidget {
  final WinToWinState state;
  final String gameType; // 'quiz' or 'reaction'

  const MatchmakingScreen({
    super.key,
    required this.state,
    required this.gameType,
  });

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  int _secondsElapsed = 0;
  Timer? _timer;
  bool _matchFound = false;

  late String _opponentName;
  late Brand _opponentBrand;

  final List<String> _botNames = [
    'Arjun Verma',
    'Neha Sharma',
    'Vikram Rajput',
    'Sneha Sen',
    'Karan Patel',
    'Ananya Iyer',
    'Rohan Nair',
  ];

  @override
  void initState() {
    super.initState();
    _pickOpponent();
    _startMatchmaking();
  }

  void _pickOpponent() {
    final rand = Random();
    _opponentName = _botNames[rand.nextInt(_botNames.length)];

    // Rival brand different from player's brand
    final otherBrands = widget.state.rankedBrands
        .where((b) => b.id != widget.state.playerBrand.id)
        .toList();
    _opponentBrand = otherBrands.isNotEmpty
        ? otherBrands[rand.nextInt(otherBrands.length)]
        : widget.state.topBrand;
  }

  void _startMatchmaking() {
    // Falls back to match/bot in 3 to 5 seconds (well under the 10s PRD limit)
    final matchTime = 3 + Random().nextInt(3);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _secondsElapsed++;
      });

      if (_secondsElapsed >= matchTime && !_matchFound) {
        timer.cancel();
        _onMatchFound();
      }
    });
  }

  void _onMatchFound() {
    setState(() {
      _matchFound = true;
    });

    // Launch game after brief face-off animation
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;

      Widget targetGame;
      if (widget.gameType == 'reaction') {
        targetGame = ReactionDuelScreen(
          state: widget.state,
          opponentName: _opponentName,
          opponentBrand: _opponentBrand,
        );
      } else {
        targetGame = QuizGameScreen(
          state: widget.state,
          opponentName: _opponentName,
          opponentBrand: _opponentBrand,
        );
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => targetGame),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final myBrand = widget.state.playerBrand;

    final gameTitle = widget.gameType == 'reaction'
        ? '1v1 Reaction Duel'
        : '1v1 Brand Trivia Quiz';

    return Scaffold(
      appBar: AppBar(
        title: Text(gameTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_matchFound) ...[
                // Searching Radar Indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        widget.gameType == 'reaction'
                            ? Icons.flash_on_rounded
                            : Icons.psychology_rounded,
                        size: 52,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Searching for Opponent...',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Matching with players in your zone (${_secondsElapsed}s / 10s limit)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(myBrand.icon, size: 18, color: myBrand.brandColor),
                      const SizedBox(width: 8),
                      Text(
                        'Fighting for ${myBrand.name}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Match Found Face-Off Card!
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF10B981)),
                  ),
                  child: const Text(
                    '⚡ MATCH FOUND!',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Player
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: myBrand.brandColor,
                          child: Icon(myBrand.icon, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.state.player.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          myBrand.name,
                          style: TextStyle(color: theme.colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),

                    // VS Badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.errorContainer,
                      ),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Opponent
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: _opponentBrand.brandColor,
                          child: Icon(_opponentBrand.icon, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _opponentName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          _opponentBrand.name,
                          style: TextStyle(color: theme.colorScheme.error, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 36),
                const Text(
                  'Entering Arena in 2 seconds...',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
