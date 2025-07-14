import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'form_event.dart';
import 'form_state.dart' as form_bloc_state;

class FormBloc extends Bloc<FormEvent, form_bloc_state.FormState> {
  final FormGroup form;
  final ScrollController scrollController = ScrollController();
  final List<GlobalKey> fieldKeys = List.generate(15, (_) => GlobalKey());
  final List<FocusNode> focusNodes = List.generate(15, (_) => FocusNode());

  FormBloc(this.form) : super(form_bloc_state.FormInitial()) {
    on<SubmitFormEvent>(_onSubmit);
  }

  void _onSubmit(SubmitFormEvent event, Emitter<form_bloc_state.FormState> emit) {
    form.markAllAsTouched();
    if (form.valid) {
      emit(form_bloc_state.FormSubmitting());
      Future.delayed(const Duration(seconds: 1), () {
        emit(form_bloc_state.FormSubmitted());
      });
    } else {
      scrollToFirstError();
      emit(form_bloc_state.FormValidationError("Form contains errors"));
    }
  }

  void scrollToFirstError() {
  for (int i = 0; i < 15; i++) {
    if (form.control('field$i').invalid) {
      final context = fieldKeys[i].currentContext;
      if (context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          FocusManager.instance.primaryFocus?.unfocus();

          await Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 400),
            alignment: 0.0,
            curve: Curves.easeInOut,
          );

          Future.delayed(const Duration(milliseconds: 100), () {
            focusNodes[i].requestFocus();
            FocusScope.of(context).requestFocus(focusNodes[i]);
          });
        });
      }
      break;
    }
  }
}



  @override
  Future<void> close() {
    // Clean up focus nodes
    for (final node in focusNodes) {
      node.dispose();
    }
    scrollController.dispose();
    return super.close();
  }
}

