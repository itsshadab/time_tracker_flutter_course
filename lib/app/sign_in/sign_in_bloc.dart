import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

class SignInBloc{
  final AuthBase auth;
  SignInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose(){
    _isLoadingController.close();
  }
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> signIn(Future<User> Function() signInMethod) async{
    try{
      _setIsLoading(true);
      return await signInMethod();
    }catch(e){
      _setIsLoading(false);
      rethrow;
    }
  }
  Future<User> signInAnonymously() async => await signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await signIn(auth.signInWithGoogle);

  Future<User> signInWithFacebook() async => await signIn(auth.signInWithFacebook);
}