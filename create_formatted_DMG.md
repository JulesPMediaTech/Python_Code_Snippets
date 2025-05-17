To ensure a disk image retains folder visual settings (such as background color/image, icon positions, and window size) when deploying an application on macOS, you need to carefully follow a specific process. Here's a detailed step-by-step guide to create a properly configured DMG (Disk Image) with persistent visual attributes:

---

### ✅ **Steps to Create a Properly Configured DMG on macOS**

#### 1. **Create a Staging Folder**

This is the folder that will contain your app and any customizations.

```bash
mkdir -p dmg-staging/MyApp
cp -R /path/to/MyApp.app dmg-staging/MyApp/
```

---

#### 2. **Customize Folder Appearance in Finder**

1. Open the `dmg-staging` folder in Finder.
2. Customize:

   * Set the folder view to **Icon View** (Command + 1).
   * Set icon sizes and arrange them as needed.
   * Add a background **image** or **color** via **View > Show View Options** (Command + J).
   * Adjust the window size and position.
3. **VERY IMPORTANT**: Make sure the `“.DS_Store”` file is generated and saved. This file holds the visual configuration.
4. Close the Finder window to ensure the `.DS_Store` file is written.

---

#### 3. **Create a Read/Write Disk Image for Configuration**

```bash
hdiutil create -srcfolder dmg-staging \
  -volname "MyApp Installer" \
  -fs HFS+ \
  -format UDRW \
  MyApp-temp.dmg
```

This creates a read/write image (`UDRW`) that you can modify.

---

#### 4. **Mount and Finalize Visual Layout**

Mount the image:

```bash
hdiutil attach MyApp-temp.dmg
```

Let’s say it mounts at `/Volumes/MyApp Installer`.

* Open `/Volumes/MyApp Installer` in Finder.
* Do **final adjustments** to icon positions, background, etc., as needed.
* Again, **close the window** to save `.DS_Store`.

---

#### 5. **Set Proper Permissions (Optional but Recommended)**

Inside the mounted volume:

```bash
cd /Volumes/MyApp\ Installer
chmod -Rf go-w .
```

This makes sure no unexpected modifications can be made.

---

#### 6. **Unmount and Convert to Compressed, Read-Only Image**

Unmount the image:

```bash
hdiutil detach /Volumes/MyApp\ Installer
```

Convert it to a final compressed read-only image (`UDZO`):

```bash
hdiutil convert MyApp-temp.dmg -format UDZO -imagekey zlib-level=9 -o MyApp.dmg
```

You can now distribute `MyApp.dmg` and it will retain:

* Folder layout and icon positions
* Background color or image
* Custom window size

---

### 🔒 Notes

* Always make the `.DS_Store` changes **within** the disk image, not just the staging folder.
* Use **HFS+ (not APFS)** for the DMG format to ensure Finder layout features work (backgrounds, icon positions, etc.).
* Don’t use third-party tools to modify images **after** converting them — this can break `.DS_Store`.

---
