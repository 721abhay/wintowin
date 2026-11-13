import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/brand.dart';
import '../../models/reward.dart';
import '../../services/wintowin_state.dart';
import 'game_result_screen.dart';

enum DuelState { waiting, ready, tapped, falseStart }

class ReactionDuelScreen extends StatefulWidget {
  final WinToWinState state;
  final String opponentName;
  final Brand opponentBrand;

  const ReactionDuelScreen({
    super.key,
    required this.state,
    required this.opponentName,
    required this.opponentBrand,
  });

  @override
  State<ReactionDuelScreen> createState() => _ReactionDuelScreenState();
}

class _ReactionDuelScreenState extends State<ReactionDuelScreen> {
  int _currentRound = 1;
  int _playerRoundsWon = 0;
  int _opponentRoundsWon = 0;

  DuelState _duelState = DuelState.waiting;
  Timer? _triggerTimer;
  final Stopwatch _stopwatch = Stopwatch();

  int? _lastPlayerReactionMs;
  int? _lastOpponentReactionMs;
  String _roundFeedback = 'Tap when screen turns Green!';

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    setState(() {
      _duelState = DuelState.waiting;
      _roundFeedback = 'Wait for GREEN...';
    });

    // Random delay between 1.8s and 4.2s
    final randomDelay = 1800 + Random().nextInt(2400);

    _triggerTimer?.cancel();
    _triggerTimer = Timer(Duration(milliseconds: randomDelay), () {
      if (!mounted) return;
      _stopwatch.reset();
      _stopwatch.start();
      setState(() {
        _duelState = DuelState.ready;
        _roundFeedback = '⚡ TAP NOW!';
      });
    });
  }

  void _handleTap() {
    if (_duelState == DuelState.waiting) {
      // False start!
      _triggerTimer?.cancel();
      setState(() {
        _duelState = DuelState.falseStart;
        _opponentRoundsWon++;
        _roundFeedback = '❌ False Start! You tapped too early.';
      });
      _checkMatchEnd();
    } else if (_duelState == DuelState.ready) {
      _stopwatch.stop();
      final playerMs = _stopwatch.elapsedMilliseconds;

      // Opponent reaction between 240ms and 360ms
      final opponentMs = 240 + Random().nextInt(120);

      final playerWonRound = playerMs < opponentMs;
      if (playerWonRound) {
        _playerRoundsWon++;
      } else {
        _opponentRoundsWon++;
      }

      setState(() {
        _duelState = DuelState.tapped;
        _lastPlayerReactionMs = playerMs;
        _lastOpponentReactionMs = opponentMs;
        _roundFeedback = playerWonRound
            ? '🏆 Round $_currentRound Won! ($playerMs ms vs $opponentMs ms)'
            : '⚠️ Round $_currentRound Lost! ($playerMs ms vs $opponentMs ms)';
      });

      _checkMatchEnd();
    }
  }

  void _checkMatchEnd() {
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;

      if (_playerRoundsWon >= 2 || _opponentRoundsWon >= 2 || _currentRound >= 3) {
        _finishGame();
      } else {
        setState(() {
          _currentRound++;
        });
        _startRound();
      }
    });
  }

  void _finishGame() {
    final isWon = _playerRoundsWon > _opponentRoundsWon;
    final playerPointsAwarded = isWon ? 60 : 20;
    final brandPointsAwarded = isWon ? 60 : 15;

    Reward? dropReward;
    if (isWon && Random().nextDouble() < 0.70) {
      dropReward = Reward(
        id: 'drop_reaction_${DateTime.now().millisecondsSinceEpoch}',
        brandId: widget.state.playerBrand.id,
        brandName: widget.state.playerBrand.name,
        title: 'Reflex Trophy: 30% OFF on ${widget.state.playerBrand.name}',
        description: 'Earned by blitzing the 1v1 Reaction Duel in under 300ms!',
        type: RewardType.voucher,
        promoCode: 'REFLEX30',
        discountValue: '30% OFF',
        expiryDate: DateTime.now().add(const Duration(days: 10)),
      );
    }

    if (isWon) {
      widget.state.recordMatchWin(
        playerPointsAwarded: playerPointsAwarded,
        brandPointsAwarded: brandPointsAwarded,
        dropReward: dropReward,
      );
    } else {
      widget.state.recordMatchLoss(consolationPoints: playerPointsAwarded);
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => GameResultScreen(
          state: widget.state,
          isWon: isWon,
          playerScore: _playerRoundsWon,
          opponentScore: _opponentRoundsWon,
          opponentName: widget.opponentName,
          opponentBrand: widget.opponentBrand,
          playerPointsAwarded: playerPointsAwarded,
          brandPointsAwarded: brandPointsAwarded,
          droppedReward: dropReward,
          gameTitle: '1v1 Reaction Duel',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _triggerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color arenaColor;
    switch (_duelState) {
      case DuelState.waiting:
        arenaColor = const Color(0xFFDC2626); // Red - wait
        break;
      case DuelState.ready:
        arenaColor = const Color(0xFF10B981); // Bright Green - tap
        break;
      case DuelState.tapped:
        arenaColor = const Color(0xFF4F46E5); // Indigo - reviewing
        break;
      case DuelState.falseStart:
        arenaColor = const Color(0xFFB91C1C); // Deep Red
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Reaction Duel — Round $_currentRound of 3'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Header Scoreboard
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.state.player.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rounds Won: $_playerRoundsWon',
                      style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Best of 3',
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.opponentName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rounds Won: $_opponentRoundsWon',
                      style: const TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Interactive Arena Tap Target
          Expanded(
            child: InkWell(
              onTap: _handleTap,
              splashColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                color: arenaColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _duelState == DuelState.ready
                              ? Icons.touch_app_rounded
                              : (_duelState == DuelState.falseStart
                                  ? Icons.error_rounded
                                  : Icons.hourglass_top_rounded),
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _roundFeedback,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (_lastPlayerReactionMs != null && _duelState == DuelState.tapped) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Your Speed: $_lastPlayerReactionMs ms  •  Opponent: $_lastOpponentReactionMs ms',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
