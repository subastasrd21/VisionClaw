# Codemagic Setup para VisionClaw

Tu fork está en: **https://github.com/subastasrd21/VisionClaw.git**

## 🚀 Pasos para configurar Codemagic

### 1. Inicia sesión en Codemagic

1. Ve a https://codemagic.io
2. Presiona "Sign up" → "Sign in with GitHub"
3. Autoriza Codemagic a acceder a tus repositorios

### 2. Agregar tu repositorio a Codemagic

1. En el dashboard → "New app"
2. Selecciona `subastasrd21/VisionClaw`
3. Presiona "Continue"

### 3. Configurar variables de entorno

En **Project Settings → Environment variables → Create variable**:

```
Name: GEMINI_API_KEY
Value: AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8
Secure: ✅ (checkmark)
```

### 4. Configurar Apple Developer (para iOS)

#### Opción A: Usar Codemagic built-in (más fácil)

1. En **iOS signing** → "Fetch credentials from App Store Connect"
2. Ingresa tu Apple ID y contraseña
3. Codemagic descargará automáticamente tus certificados

#### Opción B: Manual (si prefieres)

1. Ve a https://developer.apple.com/account/resources/profiles/list
2. Crea un **Provisioning Profile** para:
   - App ID: `com.intentlab.visionclaw`
   - Dispositivos: Tu iPhone + Meta Rayban 2
3. Ve a https://developer.apple.com/account/resources/certificates/list
4. Descarga tu certificado de firma (Distribution o Development)
5. En Codemagic → iOS signing → Sube el `.mobileprovision` y certificado

### 5. Configurar Android Signing (para Rayban 2)

#### Opción A: Usar keystore existente

1. Si ya tienes un `.jks`:
   ```bash
   file release.keystore  # Verifica que exista
   ```
2. En Codemagic → Android signing → Upload keystore
3. Proporciona:
   - Archivo: `release.keystore`
   - Keystore password: `tu_contraseña`
   - Key alias: `VisionClaw`
   - Key password: `tu_contraseña`

#### Opción B: Generar nuevo keystore

```bash
keytool -genkey -v -keystore release.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias VisionClaw \
  -storepass tu_contraseña_keystore \
  -keypass tu_contraseña_key
```

Luego sube a Codemagic como en Opción A.

### 6. Lanzar el primer build

1. En Codemagic → "Start new build"
2. Selecciona:
   - Branch: `main`
   - Workflow: `vision-claw-ios` (primero)
3. Presiona "Build"

Codemagic empezará a compilar automáticamente. En ~15 minutos:
- ✅ iOS IPA listo → descargable
- ✅ Android APK listo → descargable

---

## 📱 Instalar en dispositivos

### En iPhone (desarrollo)

**Opción 1: Xcode (local)**
```bash
# Si tienes Mac
xcode-select --install
open samples/CameraAccess/CameraAccess.xcworkspace
# Presiona Play para instalar en iPhone conectado
```

**Opción 2: TestFlight (recomendado)**
1. En Codemagic → Build → "Publish to TestFlight"
2. Espera aprobación (~30 min)
3. Abre TestFlight en tu iPhone
4. Descarga VisionClaw

### En Meta Rayban 2

**Opción 1: Meta AI App integration (más fácil)**
1. Empareja tus Rayban 2 con iPhone
2. Abre la Meta AI app
3. Habilita modo Developer
4. VisionClaw detectará automáticamente las gafas

**Opción 2: Sideload APK (Android)**
```bash
# Desde Codemagic
1. Descarga el APK de Android
2. Conecta Rayban 2 a tu PC por USB
3. Ejecuta:
   adb install app-debug.apk
```

---

## 🧪 Testing sin hardware

### Prueba en iPhone (sin Rayban)

```bash
# Opción 1: Localmente con Mac (si consigues una)
cd samples/CameraAccess
pod install
open CameraAccess.xcworkspace
# Selecciona iPhone en Simulator y presiona Play
```

```bash
# Opción 2: Con Codemagic + TestFlight
# Lanza build en Codemagic
# Descarga IPA desde TestFlight
```

### Prueba en Android (sin Rayban)

```bash
# Localmente sin Mac
cd samples/CameraAccessAndroid
./gradlew clean build
./gradlew installDebug  # Instala en emulador o dispositivo conectado
```

---

## 🔑 Seguridad: Regenera tu API key

**⚠️ IMPORTANTE** después de terminar:

1. Ve a https://aistudio.google.com/apikey
2. Presiona "Delete" en la clave actual
3. Genera una nueva clave
4. En Codemagic → Environment variables → Actualiza `GEMINI_API_KEY`
5. En los archivos locales:
   ```
   samples/CameraAccess/CameraAccess/Secrets.swift
   samples/CameraAccessAndroid/app/src/main/java/.../Secrets.kt
   ```
6. Haz commit y push

---

## 🆘 Troubleshooting

| Error | Solución |
|-------|----------|
| "No provisioning profile found" | Ve a developer.apple.com y crea un perfil para `com.intentlab.visionclaw` |
| "Gemini API key invalid" | Verifica que `GEMINI_API_KEY` esté en Environment variables |
| "Cannot build Android" | Asegúrate que keystore está subido y contraseña es correcta |
| "Build timeout" | Aumenta "Max build duration" en Project settings |

---

## 📊 Monitorear build

En Codemagic dashboard:
- **Building** → Compilación en progreso
- **Success** → ✅ APK/IPA listo
- **Failed** → ❌ Ver logs para error

Haz click en el build para ver logs detallados.

---

**¿Listo?** Una vez configure Codemagic:
1. Lanza primer build (vision-claw-ios)
2. Descarga el IPA
3. Instala en iPhone
4. Prueba que Gemini funciona
5. Luego hacemos lo mismo con Android para Rayban 2

¡Cuéntame cuando tengas el primer build listo! 🚀
