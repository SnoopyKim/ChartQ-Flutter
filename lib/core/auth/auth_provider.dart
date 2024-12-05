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

  Future<UserResponse> updateUser({
    String? country,
    String? name,
    String? nickname,
    String? phone,
    Object? additional,
  }) async {
    final attributes = UserAttributes();
    if (phone != null) attributes.phone = phone;

    final Map<String, dynamic> userData = {
      if (name != null) 'name': name,
      if (country != null) 'country': country,
    };

    if (nickname != null || additional != null) {
      userData['chartq'] = {
        if (nickname != null) 'nickname': nickname,
        if (additional != null) ...(additional as Map<String, dynamic>),
      };
    }

    attributes.data = userData;
    return await supabase.auth.updateUser(attributes);
  }

  Future<void> signOut() async {
    await _googleSignInService.signOutFromGoogle();
    await supabase.auth.signOut();
  }
}
