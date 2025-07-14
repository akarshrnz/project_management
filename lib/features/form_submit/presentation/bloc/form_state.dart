abstract class FormState {}

class FormInitial extends FormState {}

class FormSubmitting extends FormState {}

class FormSubmitted extends FormState {}

class FormValidationError extends FormState {
  final String error;
  FormValidationError(this.error);
}
