import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class BookLoadRequested extends BookEvent {
  const BookLoadRequested();
}

class BookPageChanged extends BookEvent {
  final int pageNumber;

  const BookPageChanged(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class BookNextPageRequested extends BookEvent {
  const BookNextPageRequested();
}

class BookPreviousPageRequested extends BookEvent {
  const BookPreviousPageRequested();
}

class BookJumpToPage extends BookEvent {
  final int pageNumber;

  const BookJumpToPage(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

class BookSectionSelected extends BookEvent {
  final String sectionId;

  const BookSectionSelected(this.sectionId);

  @override
  List<Object?> get props => [sectionId];
}
