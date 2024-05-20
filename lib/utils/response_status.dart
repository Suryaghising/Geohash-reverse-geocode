import 'package:equatable/equatable.dart';

abstract class ResponseStatus extends Equatable {
  const ResponseStatus();

  @override
  List<Object?> get props => [];
}

class ResponseSuccess extends ResponseStatus{
  final dynamic data;
  const ResponseSuccess(this.data);

}

class ResponseFailure extends ResponseStatus {

  final String message;

  const ResponseFailure(this.message);

}
class ResponseEmpty extends ResponseStatus {}

class ResponseLoading extends ResponseStatus {}