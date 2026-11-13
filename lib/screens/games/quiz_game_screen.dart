import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/brand.dart';
import '../../models/reward.dart';
import '../../services/wintowin_state.dart';
import 'game_result_screen.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizGameScreen extends StatefulWidget {
  final WinToWinState state;
  final String opponentName;
  final Brand opponentBrand;

  const QuizGameScreen({
    super.key,
    required this.state,
    required this.opponentName,
    required this.opponentBrand,
  });

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  final List<QuizQuestion> _questions = [
    const QuizQuestion(
      question: 'Which iconic brand is famous for the motto "Just Do It"?',
      options: ['Puma', 'Nike', 'Reebok', 'Adidas'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'Which Indian audio brand was co-founded by Aman Gupta and Sameer Mehta?',
      options: ['boAt', 'Noise', 'Boult', 'Mivi'],
      correctIndex: 0,
    ),
    const QuizQuestion(
      question: 'What is the signature 3-stripe logo brand established in Germany?',
      options: ['Nike', 'New Balance', 'Adidas', 'Under Armour'],
      correctIndex: 2,
    ),
    const QuizQuestion(
      question: 'Which of the following is Puma\'s renowned brand slogan?',
      options: ['Impossible is Nothing', 'Forever Faster', 'Rule the Road', 'Think Different'],
      correctIndex: 1,
    ),
    const QuizQuestion(
      question: 'What is the name of Nike\'s famous air cushioning technology introduced in 1979?',
      options: ['Boost', 'Gel Cushion', 'Air Sole', 'Cloudfoam'],
      correctIndex: 2,
    ),
  ];

  int _currentIndex = 0;
  int _playerScore = 0;
  int _opponentScore = 0;
  int _timeLeft = 10;
  Timer? _questionTimer;

  int? _selectedAnswer;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
    _answered = false;
    _selectedAnswer = null;

    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          // Time expired
          _handleAnswer(-1);
        }
      });
    });
  }

  void _handleAnswer(int index) {
    if (_answered) return;

    _questionTimer?.cancel();
    final isCorrect = index == _questions[_currentIndex].correctIndex;

    // Simulate opponent answering (75% chance correct if player is correct, 40% if wrong)
    final opponentCorrect = Random().nextDouble() < (isCorrect ? 0.70 : 0.40);

    setState(() {
      _answered = true;
      _selectedAnswer = index;

      if (isCorrect) {
        _playerScore += 20 + (_timeLeft * 2); // Speed bonus
      }
      if (opponentCorrect) {
        _opponentScore += 20 + (Random().nextInt(7) * 2);
      }
    });

    // Advance after 1.2s delay
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;

      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
        });
        _startTimer();
      } else {
        _finishGame();
      }
    });
  }

  void _finishGame() {
    final isWon = _playerScore >= _opponentScore;
    final playerPointsAwarded = isWon ? 50 : 15;
    final brandPointsAwarded = isWon ? 50 : 10;

    Reward? dropReward;
    if (isWon && Random().nextDouble() < 0.65) {
      // 65% chance of voucher drop on victory
      dropReward = Reward(
        id: 'drop_${DateTime.now().millisecondsSinceEpoch}',
        brandId: widget.state.playerBrand.id,
        brandName: widget.state.playerBrand.name,
        title: 'Victory Perk: ₹500 OFF on ${widget.state.playerBrand.name}',
        description: 'Earned by dominating the 1v1 Trivia Duel!',
        type: RewardType.voucher,
        promoCode: 'VICTORY500',
        discountValue: '₹500 OFF',
        expiryDate: DateTime.now().add(const Duration(days: 14)),
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
          playerScore: _playerScore,
          opponentScore: _opponentScore,
          opponentName: widget.opponentName,
          opponentBrand: widget.opponentBrand,
          playerPointsAwarded: playerPointsAwarded,
          brandPointsAwarded: brandPointsAwarded,
          droppedReward: dropReward,
          gameTitle: '1v1 Brand Trivia',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentQ = _questions[_currentIndex];
    final myBrand = widget.state.playerBrand;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1} of ${_questions.length}'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Board (Player vs Opponent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Player Score
                  Row(
                    children: [
                      Icon(myBrand.icon, size: 20, color: myBrand.brandColor),
                      const SizedBox(width: 8),
                      Text(
                        'You: $_playerScore',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),

                  // Timer Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _timeLeft <= 3 ? const Color(0xFFEF4444) : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_rounded, size: 16, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${_timeLeft}s',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // Opponent Score
                  Row(
                    children: [
                      Text(
                        '${widget.opponentName.split(" ").first}: $_opponentScore',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Icon(widget.opponentBrand.icon, size: 20, color: widget.opponentBrand.brandColor),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Question Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Round ${_currentIndex + 1}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQ.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Options List
            Expanded(
              child: ListView.separated(
                itemCount: currentQ.options.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final optionText = currentQ.options[index];

                  Color? tileColor;
                  Color textColor = isDark ? Colors.white : Colors.black87;

                  if (_answered) {
                    if (index == currentQ.correctIndex) {
                      tileColor = const Color(0xFF10B981).withValues(alpha: 0.2);
                      textColor = const Color(0xFF10B981);
                    } else if (index == _selectedAnswer) {
                      tileColor = const Color(0xFFEF4444).withValues(alpha: 0.2);
                      textColor = const Color(0xFFEF4444);
                    }
                  }

                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _answered ? null : () => _handleAnswer(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: tileColor ?? (isDark ? const Color(0xFF1E293B) : Colors.white),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _answered && index == currentQ.correctIndex
                              ? const Color(0xFF10B981)
                              : (_answered && index == _selectedAnswer
                                  ? const Color(0xFFEF4444)
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              optionText,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
