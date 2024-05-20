library ase.login_context;

bool allowBiometrics = false;
bool isLogin = false;

void changeAllowBiometrics() {
  allowBiometrics = !allowBiometrics;
}

bool getAllowBiometrics() {
  return allowBiometrics;
}

void changeIsLogin() {
  isLogin = !isLogin;
}