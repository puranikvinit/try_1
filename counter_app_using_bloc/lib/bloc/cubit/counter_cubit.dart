import 'package:bloc/bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(counterValue: 0, wasInc: false));

  void inc() =>
      emit(CounterState(counterValue: state.counterValue + 1, wasInc: true));

  void dec() =>
      emit(CounterState(counterValue: state.counterValue - 1, wasInc: false));

  void reset() =>
      emit(CounterState(counterValue: 0, wasInc: false));
}
