import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);


  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {

    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {

      userCreate(
          name: name,
          email: email,
          phone: phone,
          uId: value.user!.uid,
      );
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
}) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'Write your bio ...',
      cover: 'https://img.freepik.com/free-photo/tasty-fresh-appetizing-italian-food-ingredients-dark-background-ready-cook-home-italian-healthy-food-cooking-concept-toning_1220-1820.jpg?t=st=1653066043~exp=1653066643~hmac=d36cf3c0900e6f2cf23ce22e967e6ebecc7dd56e6a661245da5e727aa6adec1f&w=740 ',
      image: 'https://img.freepik.com/free-photo/shocked-curly-haired-woman-keeps-hands-cheeks-stares-bugged-eyes-camera-has-surprised-exression-holds-breath-wears-casual-blue-jumper-isolated-pink-background-human-reactions-concept_273609-59468.jpg?w=740',
      isEmailVerified: false,
    );
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(model.toMap())
          .then((value) {
            emit(CreateUserSuccessState());
      }).catchError((error) {
        emit(CreateUserErrorState(error.toString()));
      });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(RegisterChangePasswordVisibility());
  }
}
