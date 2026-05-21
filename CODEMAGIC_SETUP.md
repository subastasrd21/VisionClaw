# Codemagic Setup para VisionClaw (basado en Driports)

Tu fork está en: **https://github.com/subastasrd21/VisionClaw.git**

## ✅ Configuración automática → TestFlight

**SÍ**, Codemagic **subirá automáticamente a TestFlight** después de compilar exitosamente.

El workflow `vision-claw-ios` incluye:
```yaml
publishing:
  app_store_connect:
    auth: integration
    submit_to_testflight: true    # ← Auto-sube después del build
```

---

## 🚀 Pasos para configurar (como Driports)

### 1. Inicia sesión en Codemagic

```
https://codemagic.io → "Sign up" → "Sign in with GitHub"
Usa: subastasrd21
```

### 2. Agregar tu repositorio

```
Dashboard → "New app"
Selecciona: subastasrd21/VisionClaw
Presiona "Continue"
```

### 3. Configurar App Store Connect Integration ⭐

Este es el paso clave que conecta con TestFlight automáticamente.

**3a. En App Store Connect:**
1. Ve a https://appstoreconnect.apple.com
2. Account → Users and Access → Keys (API)
3. Presiona "+" para crear nueva clave
4. Selecciona "App Manager" como rol
5. Descarga el `.p8` file (solo se descarga una vez)
6. Copia los valores:
   - Issuer ID
   - Key ID

**3b. En Codemagic:**
1. Team Settings → Integrations → App Store Connect
2. Presiona "Connect" / "Add new"
3. Nombre: **"VisionClaw App Store Connect"**
4. Pega en Codemagic:
   - Issuer ID
   - Key ID
   - Contenido del `.p8` file (abre en editor de texto)
5. Presiona "Save"

✅ Codemagic ahora puede publicar en TestFlight automáticamente.

### 4. Crear grupos de variables de entorno

**Grupo 1: visionclaw-secrets** (marcar cada una como "Secret")

| Variable | Valor |
|----------|-------|
| `GEMINI_API_KEY` | `AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8` |
| `DISTRIBUTION_CERT_B64` | Tu certificado .p12 en base64 |
| `DISTRIBUTION_CERT_PASSWORD` | Contraseña de tu certificado |

**Cómo obtener DISTRIBUTION_CERT_B64:**
```bash
# En tu Mac o WSL:
base64 -w0 ~/path/to/distribution_cert.p12 && echo

# Copia todo el output (sin saltos de línea)
# Pégalo en DISTRIBUTION_CERT_B64
```

**Grupo 2: visionclaw-config** (valores normales, NO secret)

| Variable | Valor |
|----------|-------|
| `BUNDLE_ID` | `com.intentlab.visionclaw` |
| `APP_STORE_APPLE_ID` | Tu App ID de App Store (ej: 6544789743) |

### 5. Configurar certificados y provisioning profiles

**5a. Crear provisioning profile:**

1. Ve a https://developer.apple.com/account/resources/profiles/list
2. Presiona "+"
3. Selecciona "App Store"
4. Bundle ID: `com.intentlab.visionclaw`
5. Certificados: Selecciona tu certificado de distribución
6. Dispositivos: Selecciona todos tus dispositivos (iPhone + Meta Rayban 2)
7. Presiona "Continue" → "Generate" → "Download"

**5b. Commit del profile:**
```bash
# En tu repo VisionClaw (raíz):
mkdir -p ios/codemagic
cp ~/Downloads/VisionClaw_App_Store.mobileprovision ios/codemagic/
git add ios/codemagic/VisionClaw_App_Store.mobileprovision
git commit -m "chore: add App Store provisioning profile"
git push
```

### 6. Obtener certificado de distribución

**Si ya lo tienes:**
```bash
# Convierte a base64
base64 -w0 ~/path/to/distribution_cert.p12 > cert_b64.txt

# Copia el contenido a DISTRIBUTION_CERT_B64 en Codemagic
cat cert_b64.txt | pbcopy  # en Mac
# o simplemente cat cert_b64.txt y copia manualmente
```

**Si no lo tienes:**
1. Ve a https://developer.apple.com/account/resources/certificates/list
2. Presiona "+"
3. Selecciona "Apple Distribution"
4. Sigue los pasos
5. Descarga el `.cer`
6. Abre en Keychain Access → Export como `.p12`
7. Convierte a base64 (ver arriba)

---

## 🎯 Lanzar primer build

1. En Codemagic → Proyecto VisionClaw
2. Presiona "Start new build"
3. Selecciona:
   - Branch: `main`
   - Workflow: `vision-claw-ios`
4. Presiona "Build"

**¿Qué pasa automáticamente?**
```
1. ✅ Compila iOS en Mac Mini (Codemagic)
2. ✅ Firma con tu certificado + provisioning profile
3. ✅ Crea IPA
4. ✅ SUBE AUTOMÁTICAMENTE A TESTFLIGHT
5. 📧 Te envía email de confirmación
```

**Tiempo estimado:** 20-30 minutos

---

## 📱 Instalar desde TestFlight

Una vez que el build está en TestFlight:

1. En tu iPhone, abre **TestFlight** app
2. Busca "VisionClaw"
3. Presiona "Install"
4. Espera que se complete (~2-5 min)
5. Abre VisionClaw
6. Presiona "Permitir" cuando pida acceso a cámara/micrófono
7. ¡Listo! Deberías ver video de tu iPhone en tiempo real procesado por Gemini

---

## 🤖 Android (opcional después)

Mismo proceso pero con Google Play Console:

**Prerequisitos:**
1. Crear un keystore (como Driports)
2. Subir a Codemagic como env var `ANDROID_KEYSTORE`
3. El workflow `vision-claw-android` automáticamente:
   - Compila APK
   - Compila AAB (bundle)
   - Sube a Play Store en track "internal"

---

## 📚 Referencia: Variables de entorno en Codemagic

### visionclaw-secrets (grupo)
```
GEMINI_API_KEY=AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8
DISTRIBUTION_CERT_B64=MIIJZQIBAzCCCRwGCSqGSIb3DQEBBQAwggkO... (largo)
DISTRIBUTION_CERT_PASSWORD=tu_contraseña
```

### visionclaw-config (grupo)
```
BUNDLE_ID=com.intentlab.visionclaw
APP_STORE_APPLE_ID=6544789743  (cámbialo por tu App ID)
```

---

## 🔐 Seguridad: Regenera API key después

Una vez que TestFlight build esté exitoso:

```bash
# 1. Ve a https://aistudio.google.com/apikey
# 2. Elimina la clave actual
# 3. Genera nueva clave
# 4. En Codemagic UI: actualiza GEMINI_API_KEY
# 5. Localmente:

sed -i 's/AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8/TU_NUEVA_CLAVE/g' \
  samples/CameraAccess/CameraAccess/Secrets.swift \
  samples/CameraAccessAndroid/app/src/main/java/com/meta/wearable/dat/externalsampleapps/cameraaccess/Secrets.kt

git add -A && git commit -m "chore: update Gemini API key" && git push
```

---

## 🆘 Troubleshooting

| Error | Solución |
|-------|----------|
| "No matching provisioning profile" | Verifica que `ios/codemagic/VisionClaw_App_Store.mobileprovision` existe en repo |
| "Certificate not found" | Asegúrate que DISTRIBUTION_CERT_B64 y password son correctos |
| "App Store Connect API error" | Regenera el `.p8` file desde developer.apple.com |
| "Build timeout (>90 min)" | Aumenta `max_build_duration` en `codemagic.yaml` |

---

**¿Preguntas?** Cuéntame cuando tengas configurado App Store Connect en Codemagic. Luego lanzamos el primer build. 🚀
