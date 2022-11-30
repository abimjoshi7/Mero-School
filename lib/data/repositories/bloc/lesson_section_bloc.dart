import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mero_school/data/models/response/curriculum_data_res_model.dart';
import 'package:mero_school/data/repositories/lesson_section_repo.dart';

part 'lesson_section_event.dart';
part 'lesson_section_state.dart';

class LessonSectionBloc extends Bloc<LessonSectionEvent, LessonSectionState> {
  final LessonSectionRepo lessonSectionRepo;
  LessonSectionBloc(
    this.lessonSectionRepo,
  ) : super(LessonSectionInitial()) {
    on<LessonSectionRequested>(
      (event, emit) {
        if (state is LessonSectionLoading)
          emit(
            LessonSectionLoading(
              CircularProgressIndicator(),
            ),
          );
        else if (state is LessonSectionLoaded) {
          emit(
            LessonSectionLoaded(
              curriculumDataResModel: lessonSectionRepo.getCurrData(97),
            ),
          );
        } else {
          emit(
            LessonSectionError("Something went wrong"),
          );
        }
      },
    );
  }
}
