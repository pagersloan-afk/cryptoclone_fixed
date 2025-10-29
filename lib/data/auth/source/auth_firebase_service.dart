import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/data/auth/models/user_creation_req.dart';
import 'package:ecommerce_app/data/auth/models/user_signin_req.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSigninReq user);
  Future<Either> getAges();
  Future<Either> sendPasswordResetEmail(String email);
  Future<bool> isLoggedIn();
  Future<Either> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either<String, String>> signup(UserCreationReq user) async {
    try {
      final returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );

      await returnedData.user?.sendEmailVerification(); // ✅ Send verification

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(returnedData.user!.uid)
          .set({
            'userId': returnedData.user!.uid,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'gender': user.gender,
            'age': user.age,
            'addressLine1': user.addressLine1,
            'addressLine2': user.addressLine2,
            'city': user.city,
            'state': user.state,
            'country': user.country,
            'postalCode': user.postalCode,
            'accountBalance': '0.00',
            'status': 'Not verified',
            'walletId': '',
          });

      return Right(
        'Sign up was successful. Please check your email to verify your account.',
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else {
        message = e.message ?? 'An unexpected error occurred.';
      }
      return Left(message);
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  @override
  Future<Either<String, List<QueryDocumentSnapshot>>> getAges() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Ages')
          .get();
      return Right(returnedData.docs);
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either<String, String>> signin(UserSigninReq user) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );

      final currentUser = userCredential.user;

      if (currentUser != null && !currentUser.emailVerified) {
        await currentUser.sendEmailVerification(); // Optional: resend
        return Left(
          'Please verify your email before logging in. A new verification link has been sent.',
        );
      }

      return Right('Sign in was successful');
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'invalid-email') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'The password is incorrect';
      } else {
        message = e.message ?? 'Sign in failed. Please check your credentials.';
      }
      return Left(message);
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }

  @override
  Future<Either<String, String>> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Right('Password reset email sent successfully.');
    } catch (e) {
      return Left('An error occurred while sending the password reset email.');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  @override
  Future<Either> getUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return Left('Please try again');
    }
  }
}
