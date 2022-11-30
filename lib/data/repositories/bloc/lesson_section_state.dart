part of 'lesson_section_bloc.dart';

abstract class LessonSectionState extends Equatable {
  const LessonSectionState();
}

class LessonSectionInitial extends LessonSectionState {
  @override
  List<Object?> get props => [];
}

class LessonSectionLoading extends LessonSectionState {
  final Widget widget;

  LessonSectionLoading(this.widget);
  List<Object?> get props => [widget];
}

class LessonSectionLoaded extends LessonSectionState {
  final Future<CurriculumDataResModel> curriculumDataResModel;
  LessonSectionLoaded({
    required this.curriculumDataResModel,
  });
  List<Object?> get props => [curriculumDataResModel];
}

class LessonSectionError extends LessonSectionState {
  final String error;

  LessonSectionError(this.error);

  @override
  List<Object?> get props => [error];
}
