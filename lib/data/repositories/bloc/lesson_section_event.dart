part of 'lesson_section_bloc.dart';

abstract class LessonSectionEvent extends Equatable {
  const LessonSectionEvent();
}

class LessonSectionRequested extends LessonSectionEvent {
  @override
  List<Object?> get props => [];
}
