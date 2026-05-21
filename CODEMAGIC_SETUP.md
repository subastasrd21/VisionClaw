# Codemagic Setup para VisionClaw (Windows/WSL + Ad Hoc Sideload)

Tu fork está en: **https://github.com/subastasrd21/VisionClaw.git**

## ✨ Setup sin Mac: Codemagic (nube) + Windows (local)

- Codemagic compila en Mac Mini (cloud) ✅
- Descargas el IPA en Windows
- Instalas en iPhone desde Windows/WSL ✅

---

## 🚀 Pasos (4 principales)

### 1️⃣ Registrarse en Codemagic (5 min)

```
https://codemagic.io → "Sign up" → "Sign in with GitHub"
Usa: subastasrd21
```

### 2️⃣ Agregar tu repositorio (2 min)

```
Dashboard → "New app"
Selecciona: subastasrd21/VisionClaw
Presiona "Continue"
```

### 3️⃣ Crear grupo de variables (5 min)

**Grupo: visionclaw-secrets** (marcar TODAS como "Secret")

| Variable | Valor |
|----------|-------|
| `GEMINI_API_KEY` | `AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8` |
| `DEVELOPMENT_CERT_B64` | Tu certificado .p12 en base64 |
| `DEVELOPMENT_CERT_PASSWORD` | Contraseña de tu certificado |

**Grupo: visionclaw-config** (valores normales, NO secret)

| Variable | Valor |
|----------|-------|
| `BUNDLE_ID` | `com.intentlab.visionclaw` |

---

## 📜 Obtener tu Development Certificate

### Opción A: Si ya lo tienes (de Driports)

En **WSL**:
```bash
# Localiza tu certificado .p12
find ~ -name "*.p12" 2>/dev/null

# Convierte a base64
base64 -w0 ~/path/to/development_cert.p12 > /tmp/cert_b64.txt

# Copia el contenido
cat /tmp/cert_b64.txt
# Selecciona todo, copia a Codemagic
```

### Opción B: Si no lo tienes

Necesitarás acceso temporal a:
- macOS (prestada) O
- Windows con iTunes + AppleMobileDeviceService O
- Contactar a alguien con Mac para que lo exporte

Una vez tengas el `.p12`:
```bash
# En WSL:
base64 -w0 ~/Downloads/development_cert.p12 > /tmp/cert_b64.txt
cat /tmp/cert_b64.txt
```

---

## 📱 Crear Ad Hoc Provisioning Profile

**IMPORTANTE**: Necesitas el **UDID de tu iPhone**.

### A. Obtener UDID:

```bash
# En Windows: iTunes → Device → UDID
# O conecta iPhone a WSL y ejecuta:

# Instalar libimobiledevice en WSL (una sola vez)
sudo apt update && sudo apt install -y libimobiledevice6

# Obtener UDID
idevice_id -l
```

### B. Crear Profile en Apple Developer:

1. Ve a https://developer.apple.com/account/resources/profiles/list
2. Presiona **"+"**
3. Selecciona **"Ad Hoc"**
4. **App ID**: `com.intentlab.visionclaw`
5. **Certificados**: Selecciona tu Development Certificate
6. **Devices**: Checkea tu iPhone (con UDID)
7. **Continue** → **Generate** → **Download**

### C. Commit al repo:

```bash
# En tu repo VisionClaw (Windows o WSL):
mkdir -p ios/codemagic
mv ~/Downloads/VisionClaw_Ad_Hoc.mobileprovision ios/codemagic/

git add ios/codemagic/
git commit -m "chore: add Ad Hoc provisioning profile for sideload"
git push
```

---

## 🎯 Lanzar primer build (15 min)

1. En Codemagic → Proyecto VisionClaw
2. Presiona **"Start new build"**
3. Selecciona:
   - Branch: `main`
   - Workflow: `vision-claw-ios`
4. Presiona **"Build"**

**Espera ~15 minutos.** Cuando esté listo:

```
✅ Build completo
✅ Email de notificación
✅ Artifacts → build/ipa/CameraAccess.ipa
```

---

## 📥 Descargar e instalar el IPA (en Windows)

### Paso A: Descargar IPA

1. En Codemagic, ve a **Artifacts**
2. Descarga `build/ipa/CameraAccess.ipa`
3. Guarda en: `C:\Users\maclo\Downloads\CameraAccess.ipa`

### Paso B: Instalar en iPhone (3 opciones)

#### **Opción 1: iTunes (más simple)**

```
1. Abre iTunes en Windows
2. Conecta iPhone
3. Arrastra CameraAccess.ipa a iTunes
4. Selecciona tu iPhone
5. Presiona Install/Sync
```

#### **Opción 2: Windows Device Portal (si iOS 17+)**

```
1. En iPhone: Settings → Developer
2. Enable Developer Mode
3. Enable Wireless Device Portal
4. En Windows: Busca "Windows Device Portal"
5. Ingresa IP de tu iPhone
6. Upload IPA
```

#### **Opción 3: WSL + libimobiledevice (recomendado)**

```bash
# En WSL, instala herramientas (una sola vez)
sudo apt update
sudo apt install -y libimobiledevice6 libimobiledevice-utils

# Conecta iPhone a Windows por USB
# Luego en WSL:

# Verifica que se ve el iPhone
idevice_id -l
# Deberías ver tu UDID

# Descarga el IPA (está en Windows)
cp /mnt/c/Users/maclo/Downloads/CameraAccess.ipa ~/CameraAccess.ipa

# Instala en iPhone
ios-app-installer -i ~/CameraAccess.ipa
# O si eso no funciona:
ideviceinstaller -i ~/CameraAccess.ipa
```

---

## 🎉 Listo

Una vez instalado:
1. Abre VisionClaw en tu iPhone
2. Presiona "Permitir" para cámara/micrófono
3. ¡Debería ver video en tiempo real + Gemini procesando!

---

## 🔄 Workflow para desarrollo rápido

```bash
# 1. En WSL, haces cambios al código
git add -A
git commit -m "feat: cambio aquí"
git push

# 2. En Codemagic UI:
# Start new build → vision-claw-ios → Build
# Espera ~15 min

# 3. Descarga IPA desde Codemagic UI
# (guardas en Downloads)

# 4. Instala en iPhone (iTunes o WSL)
ios-app-installer -i ~/CameraAccess.ipa

# 5. Prueba en iPhone
```

---

## 🔐 Seguridad: Regenera API key después

Una vez que todo funciona:

```bash
# 1. Ve a https://aistudio.google.com/apikey
# 2. Presiona "Delete" en la clave actual
# 3. Genera nueva clave
# 4. En Codemagic → visionclaw-secrets → actualiza GEMINI_API_KEY
# 5. Localmente en WSL:

sed -i 's/AIzaSyBO0qrKrRJ0PflM-Qf4-5ddtYiiD5h3Ht8/TU_NUEVA_CLAVE/g' \
  samples/CameraAccess/CameraAccess/Secrets.swift \
  samples/CameraAccessAndroid/app/src/main/java/com/meta/wearable/dat/externalsampleapps/cameraaccess/Secrets.kt

git add -A && git commit -m "chore: update Gemini API key" && git push
```

---

## 🔗 Herramientas Windows

**iTunes**: https://www.apple.com/itunes/download/ (Windows)

**libimobiledevice en WSL**:
```bash
sudo apt install -y libimobiledevice6 libimobiledevice-utils
```

---

## 🆘 Troubleshooting

| Error | Solución |
|-------|----------|
| "Provisioning profile not found" | Verifica que `ios/codemagic/VisionClaw_Ad_Hoc.mobileprovision` existe en repo |
| "Certificate not found" en Codemagic | Asegúrate que DEVELOPMENT_CERT_B64 y password son correctos |
| iPhone no aparece en iTunes | Instala/actualiza iTunes desde Microsoft Store |
| `idevice_id: command not found` en WSL | Ejecuta: `sudo apt install libimobiledevice-utils` |
| "Device not trusted" en iPhone | Presiona "Trust" en el popup del iPhone |

---

**¿Listo?** Cuéntame cuando tengas:
1. ✅ Development Certificate (base64)
2. ✅ Ad Hoc Profile (commit al repo)
3. ✅ Variables en Codemagic

Luego lanzamos el primer build. 🚀
