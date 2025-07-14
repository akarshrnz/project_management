import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../bloc/form_bloc.dart';
import '../bloc/form_event.dart';
import '../bloc/form_state.dart' as form_bloc_state;

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  FormGroup buildForm() {
    return fb.group({
      for (int i = 0; i < 15; i++)
        'field$i': FormControl<String>(validators: [Validators.required])
    });
  }

  @override
  Widget build(BuildContext context) {
    final form = buildForm();

    return BlocProvider(
      create: (_) => FormBloc(form),
      child: Builder(
        builder: (context) {
          final bloc = context.read<FormBloc>();

          return Scaffold(
            appBar: AppBar(title: const Text("Form with 15 Fields")),
            body: BlocListener<FormBloc, form_bloc_state.FormState>(
              listener: (context, state) {
                if (state is form_bloc_state.FormSubmitted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Form submitted successfully")),
                  );
                }
              },
              child: ReactiveForm(
                formGroup: form,
                child: SingleChildScrollView(
                  controller: bloc.scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (int i = 0; i < 15; i++)
  Padding(
    key: bloc.fieldKeys[i],
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: ReactiveTextField<String>(
      formControlName: 'field$i',
      focusNode: bloc.focusNodes[i], 
      decoration: InputDecoration(
        labelText: 'Field $i',
        border: OutlineInputBorder(),
      ),
      validationMessages: {
        ValidationMessage.required: (_) => 'Field $i is required',
      },
    ),
  ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<FormBloc>().add(SubmitFormEvent());
                        },
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
