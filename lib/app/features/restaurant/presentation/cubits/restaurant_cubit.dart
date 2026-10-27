import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/restaurant_entity.dart';
import '../../data/services/restaurant_service.dart';
import 'restaurant_state.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  final RestaurantService service;

  RestaurantCubit({required this.service}) : super(const RestaurantInitial());

  Future<void> loadRestaurant() async {
    emit(const RestaurantLoading());
    try {
      final info = await service.getRestaurantInfo();
      emit(RestaurantLoaded(restaurant: info));
    } catch (e) {
      emit(RestaurantError('فشل في تحميل بيانات المطعم: ${e.toString()}'));
    }
  }

  Future<bool> updateRestaurant(RestaurantEntity updated) async {
    final currentState = state;
    if (currentState is RestaurantLoaded) {
      emit(currentState.copyWith(isSaving: true, clearMessages: true));
      try {
        final success = await service.updateRestaurantInfo(updated);
        if (success) {
          emit(RestaurantLoaded(
            restaurant: updated,
            isSaving: false,
            successMessage: 'تم حفظ بيانات المطعم بنجاح',
          ));
          return true;
        } else {
          emit(currentState.copyWith(
            isSaving: false,
            errorMessage: 'فشل في حفظ البيانات، يُرجى المحاولة لاحقاً',
          ));
          return false;
        }
      } catch (e) {
        emit(currentState.copyWith(
          isSaving: false,
          errorMessage: 'حدث خطأ: ${e.toString()}',
        ));
        return false;
      }
    } else {
      // If not loaded yet, save directly
      final success = await service.updateRestaurantInfo(updated);
      if (success) {
        emit(RestaurantLoaded(restaurant: updated));
        return true;
      }
      return false;
    }
  }

  Future<void> resetDefaults() async {
    final currentState = state;
    if (currentState is RestaurantLoaded) {
      emit(currentState.copyWith(isSaving: true, clearMessages: true));
      try {
        final defaults = await service.resetToDefaults();
        emit(RestaurantLoaded(
          restaurant: defaults,
          isSaving: false,
          successMessage: 'تمت استعادة الإعدادات الافتراضية بنجاح',
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSaving: false,
          errorMessage: 'فشل في استعادة الإعدادات الافتراضية',
        ));
      }
    }
  }

  void clearMessages() {
    final currentState = state;
    if (currentState is RestaurantLoaded) {
      emit(currentState.copyWith(clearMessages: true));
    }
  }
}
