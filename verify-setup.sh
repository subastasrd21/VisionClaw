#!/bin/bash

echo "🔍 Verificando configuración de VisionClaw..."
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CHECKS_PASSED=0
CHECKS_FAILED=0

# Función para verificar
check() {
  if eval "$1"; then
    echo -e "${GREEN}✅${NC} $2"
    ((CHECKS_PASSED++))
  else
    echo -e "${RED}❌${NC} $2"
    ((CHECKS_FAILED++))
  fi
}

echo "📱 iOS Configuration:"
check "[ -f samples/CameraAccess/CameraAccess/Secrets.swift ]" "Secrets.swift existe"
check "grep -q 'AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8' samples/CameraAccess/CameraAccess/Secrets.swift" "API key configurada en Secrets.swift"
check "[ -f samples/CameraAccess/CameraAccess.xcworkspace/contents.xcworkspacedata ]" "Xcode workspace existe"

echo ""
echo "🤖 Android Configuration:"
check "[ -f samples/CameraAccessAndroid/app/src/main/java/com/meta/wearable/dat/externalsampleapps/cameraaccess/Secrets.kt ]" "Secrets.kt existe"
check "grep -q 'AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8' samples/CameraAccessAndroid/app/src/main/java/com/meta/wearable/dat/externalsampleapps/cameraaccess/Secrets.kt" "API key configurada en Secrets.kt"
check "[ -f samples/CameraAccessAndroid/build.gradle.kts ]" "Gradle build script existe"

echo ""
echo "⚙️  CI/CD Configuration:"
check "[ -f codemagic.yaml ]" "codemagic.yaml existe"
check "grep -q 'vision-claw-ios' codemagic.yaml" "Workflow iOS configurado"
check "grep -q 'vision-claw-android' codemagic.yaml" "Workflow Android configurado"

echo ""
echo "📚 Documentation:"
check "[ -f SETUP.md ]" "SETUP.md existe"
check "[ -f CODEMAGIC_SETUP.md ]" "CODEMAGIC_SETUP.md existe"

echo ""
echo "🔐 Security:"
check "grep -q 'samples/CameraAccess/CameraAccess/Secrets.swift' .gitignore" "Secrets.swift ignorado en git"
check "grep -q 'samples/CameraAccessAndroid/app/src/main/java.*Secrets.kt' .gitignore" "Secrets.kt ignorado en git"

echo ""
echo "📡 Git Remote:"
check "git remote get-url origin | grep -q 'subastasrd21/VisionClaw'" "Remote apunta a tu fork"

echo ""
echo "════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Checks passed: $CHECKS_PASSED${NC}"
if [ $CHECKS_FAILED -gt 0 ]; then
  echo -e "${RED}❌ Checks failed: $CHECKS_FAILED${NC}"
  echo ""
  echo "Por favor revisa SETUP.md o CODEMAGIC_SETUP.md para más información."
  exit 1
else
  echo ""
  echo -e "${GREEN}🎉 ¡Todo listo para Codemagic!${NC}"
  echo ""
  echo "Próximos pasos:"
  echo "1. Ve a https://codemagic.io"
  echo "2. Inicia sesión con GitHub (usa subastasrd21)"
  echo "3. Agrega tu repositorio VisionClaw"
  echo "4. Configura variables de entorno (GEMINI_API_KEY)"
  echo "5. Configura Apple Developer y Android Signing"
  echo "6. Lanza tu primer build"
  echo ""
  exit 0
fi
