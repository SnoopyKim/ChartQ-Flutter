import 'package:chart_q/core/utils/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chart_q/core/supabase/supabase_client.dart';
import 'google_sign_in_service.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  @override
  Stream<AuthState?> build() {
    return supabase.auth.onAuthStateChange;
  }

  User? get user => supabase.auth.currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    final account = await _googleSignInService.signInWithGoogle();
    if (account != null) {
      final googleAuth = await account.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken != null && idToken != null) {
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          accessToken: accessToken,
          idToken: idToken,
        );
      }
    }
  }

  Future<void> signInWithApple() async {
    // final account = await _facebookSignInService.signInWithFacebook();
  }

  Future<void> signInWithFacebook() async {
    // final account = await _facebookSignInService.signInWithFacebook();
    // final result = await FacebookAuth.instance.login();
    // if (result.status == LoginStatus.success) {
    //   final accessToken = result.accessToken!.token;
    //   await supabase.auth.signInWithIdToken(
    //     provider: OAuthProvider.facebook,
    //     idToken: accessToken,
    //   );
    // } else {
    //   logger.d('${result.status.name}: ${result.message}');
    // }
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: kIsWeb ? null : 'com.chartq.app://login-callback',
      authScreenLaunchMode:
          kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
    );
  }

  Future<UserResponse> updateUser({
    String? country,
    String? name,
    String? nickname,
    String? phone,
    String? userType,
    bool? isWelcomed,
  }) async {
    final attributes = UserAttributes();
    attributes.data = {
      if (name != null) 'name': name,
      if (country != null) 'country': country,
      if (phone != null) 'phone': phone,
      if (nickname != null) 'chartq_nickname': nickname,
      if (userType != null) 'chartq_user_type': userType,
      if (isWelcomed != null) 'chartq_is_welcomed': isWelcomed,
    };

    return await supabase.auth.updateUser(attributes);
  }

  Future<void> signOut() async {
    await _googleSignInService.signOutFromGoogle();
    await supabase.auth.signOut();
  }
}
