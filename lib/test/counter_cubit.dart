import 'package:bloc/bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterInitial> {
  CounterCubit() : super(CounterInitial(counterValue: 0));
  void onIncrement() => emit(
        CounterInitial(counterValue: state.counterValue + 1),
      );

  void onDecrement() {
    if (state.counterValue > 0) {
      emit(
        CounterInitial(counterValue: state.counterValue - 1),
      );
    }
  }
}
