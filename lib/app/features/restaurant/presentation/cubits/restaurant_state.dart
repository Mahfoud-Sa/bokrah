import 'package:equatable/equatable.dart';
import '../../data/models/restaurant_entity.dart';

sealed class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

class RestaurantLoaded extends RestaurantState {
  final RestaurantEntity restaurant;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  const RestaurantLoaded({
    required this.restaurant,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  RestaurantLoaded copyWith({
    RestaurantEntity? restaurant,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return RestaurantLoaded(
      restaurant: restaurant ?? this.restaurant,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        restaurant,
        isSaving,
        errorMessage,
        successMessage,
      ];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}
