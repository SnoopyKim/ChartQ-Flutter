import 'package:chart_q/core/utils/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_SIGN_IN_IOS_CLIENT_ID'],
    serverClientId: dotenv.env['GOOGLE_SIGN_IN_WEB_CLIENT_ID'],
    scopes: ['openid', 'email', 'profile'],
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      logger.e('Google sign-in error: $error');
      return null;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }
}
