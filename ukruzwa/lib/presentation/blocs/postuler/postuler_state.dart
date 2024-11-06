abstract class PostulerState {
  const PostulerState();
}

class PostulerStateInitial extends PostulerState {
  const PostulerStateInitial() : super();
}

class PostulerStateCreateStatut extends PostulerState {
  final bool isSuccess;
  PostulerStateCreateStatut({required this.isSuccess});
}
