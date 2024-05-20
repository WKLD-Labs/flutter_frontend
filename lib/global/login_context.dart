library ase.login_context;

bool allowBiometrics = false;

void changeAllowBiometrics() {
  allowBiometrics = !allowBiometrics;
}

bool getAllowBiometrics() {
  return allowBiometrics;
}