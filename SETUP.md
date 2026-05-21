# VisionClaw Setup Guide

## ✅ Configuración completada automáticamente

- [x] API key de Gemini configurada en `Secrets.swift` (iOS)
- [x] API key de Gemini configurada en `Secrets.kt` (Android)
- [x] Workflow de Codemagic creado (`codemagic.yaml`)
- [x] `.gitignore` actualizado para proteger credenciales

---

## 🚀 Próximos pasos: Configurar Codemagic

### 1. Hacer fork del repositorio

Como quieres mejoras futuras, haz un fork en GitHub:

```bash
# En https://github.com/Intent-Lab/VisionClaw
# Presiona "Fork" en la esquina superior derecha
# Clona tu fork:
git clone https://github.com/TU_USUARIO/VisionClaw.git
cd VisionClaw
```

### 2. Registrarse en Codemagic

1. Ve a https://codemagic.io
2. Presiona "Sign up" → "Sign in with GitHub"
3. Autoriza Codemagic a acceder a tus repositorios
4. Selecciona el fork de VisionClaw

### 3. Configurar variables de entorno en Codemagic

En el dashboard de Codemagic → Project settings → Environment variables:

```
GEMINI_API_KEY = AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8
```

⚠️ **Después de terminar**, ve a https://aistudio.google.com/apikey y regenera la API key para mayor seguridad.

### 4. Configurar Apple Developer (para iOS)

En Codemagic → iOS Signing:

1. **Provisioning Profile:**
   - Ve a https://developer.apple.com/account/resources/profiles/list
   - Crea un perfil de provisioning para `com.intentlab.visionclaw`
   - Descárgalo y súbelo a Codemagic

2. **Certificate:**
   - Ve a https://developer.apple.com/account/resources/certificates/list
   - Descarga tu certificado de firma
   - Súbelo a Codemagic

### 5. Configurar Android (Meta Rayban 2)

En Codemagic → Android Signing:

1. Sube tu keystore (archivo `.jks`)
2. Proporciona contraseña de keystore
3. Proporciona alias y contraseña de clave

**Si no tienes un keystore:**
```bash
keytool -genkey -v -keystore release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias VisionClaw
```

### 6. Configurar Meta Developers (para testing en Rayban)

1. Ve a https://developers.meta.com/
2. Crea una aplicación nuevo
3. Agrega capacidad para Meta Wearables
4. Obtén el App ID y Secret
5. Configúra en Codemagic (variables de entorno)

---

## 📱 Testing sin hardware

Ambas plataformas permiten testing usando la cámara del dispositivo:

### iOS (sin Rayban)
```
1. Abre Xcode
2. Selecciona Simulator (iPhone 15 o similar)
3. Build and Run
4. La app usará la cámara del iPhone
```

### Android (sin Rayban)
```
1. Abre Android Studio
2. Selecciona emulador
3. Corre: ./gradlew installDebug
4. La app usará la cámara del emulador
```

---

## 🔧 Compilación manual (sin Codemagic)

### iOS
```bash
cd samples/CameraAccess
pod install
open CameraAccess.xcworkspace
# En Xcode: Product → Build
```

### Android
```bash
cd samples/CameraAccessAndroid
./gradlew clean build
./gradlew assembleDebug
```

---

## 📡 Características principales

- ✅ **Gemini Live API** - Video + Audio en tiempo real
- ✅ **Meta Rayban 2** - Captura desde gafas
- ✅ **OpenClaw** (opcional después) - 56+ herramientas integradas
- ✅ **WebRTC** (opcional) - Stream a navegadores

---

## 🆘 Troubleshooting

**Error: "Cannot find Secrets.swift"**
- Confirma que el archivo está en: `samples/CameraAccess/CameraAccess/Secrets.swift`

**Error: "Gemini API key invalid"**
- Verifica que la key esté correctamente configurada
- Regenera en https://aistudio.google.com/apikey

**Error: "No provisioning profiles found" (iOS)**
- Ve a https://developer.apple.com/account/resources/profiles/list
- Crea un nuevo perfil para `com.intentlab.visionclaw`

---

## 📚 Documentación oficial

- [Google Gemini Live API](https://ai.google.dev/gemini-live/)
- [Meta Wearables DAT SDK](https://developers.meta.com/docs/wearables/data-access/)
- [Codemagic Docs](https://docs.codemagic.io)

---

**¿Listo?** Cuéntame cuando hayas configurado Codemagic y testea la compilación. Luego agregamos **OpenClaw** para las herramientas. 🚀
