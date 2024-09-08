import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final verificationCodeProvider =
    StateNotifierProvider<VerificationCodeNotifier, List<String>>((ref) {
  return VerificationCodeNotifier();
});

class VerificationCodeNotifier extends StateNotifier<List<String>> {
  VerificationCodeNotifier() : super(List.filled(6, ''));

  void uopdateCode(int index, String value) {
    state = [
      for (int i = 0; i < state.length; i++) i == index ? value : state[i]
    ];
  }

  void clearAllCode() {
    state = List.filled(6, '');
  }

  String getCompleteCode() {
    return state.join();
  }

  bool isCodeComplete() {
    return state.every((digit) => digit.isNotEmpty);
  }
}

class InputVerificationCode extends ConsumerWidget {
  final int index;

  const InputVerificationCode({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeState = ref.watch(verificationCodeProvider);
    final codeNotifier = ref.read(verificationCodeProvider.notifier);

    return SizedBox(
      width: 40,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: const InputDecoration(
            border: OutlineInputBorder(), counterText: ''),
        onChanged: (value) {
          codeNotifier.uopdateCode(index, value);
          if (value.isNotEmpty && index < 5) FocusScope.of(context).nextFocus();
          if (value.isEmpty && 0 < index) {
            FocusScope.of(context).previousFocus();
          }
        },
        controller: TextEditingController(text: codeState[index]),
      ),
    );
  }
}
