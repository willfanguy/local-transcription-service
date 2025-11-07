# Accessibility Permission - Important Notes

## Why Accessibility Permission is Different

Unlike microphone and speech permissions, **macOS does NOT allow apps to automatically add themselves to the Accessibility list**. This is a critical security feature of macOS to prevent malicious apps from keylogging or controlling your computer.

## What This Means for LocalDictation

1. **Manual Addition Required**: You must manually add the app to System Settings > Privacy & Security > Accessibility
2. **No Auto-Grant**: The app cannot programmatically grant itself this permission
3. **Development Builds**: Each new build gets a new path in DerivedData, so you may need to re-add it during development

## How to Grant Accessibility Permission

### For Development (Xcode builds):
1. Open System Settings > Privacy & Security > Accessibility
2. Click the '+' button
3. Navigate to: `~/Library/Developer/Xcode/DerivedData/LocalDictation-[hash]/Build/Products/Debug/`
4. Select `LocalDictation.app`
5. Enable the checkbox

**Tip**: You can drag the app directly from Finder to the Accessibility list.

### For Release Builds:
1. The app will be in `/Applications/`
2. It will stay in the same location
3. You'll only need to add it once

## Why We Need This Permission

LocalDictation requires Accessibility permission for two features:
1. **Global Hotkey Detection**: To detect the Fn key (or custom hotkey) from any application
2. **Text Insertion**: To insert transcribed text into the currently focused text field

Without this permission, the app cannot:
- Detect when you press the recording hotkey
- Insert text into other applications

## The Permission Flow

When you first launch LocalDictation:
1. **Automatic**: Microphone permission dialog appears
2. **Automatic**: Speech recognition permission dialog appears
3. **Manual**: Accessibility permission requires you to:
   - Click "Open System Settings" when prompted
   - Manually add the app as described above

## Troubleshooting

### "App keeps asking for Accessibility permission"
- Make sure you've enabled the checkbox, not just added the app to the list
- For Xcode builds, make sure you're adding the current build (path changes with each rebuild)

### "I added it but it's not working"
- Try removing and re-adding the app
- Make sure LocalDictation is checked/enabled in the list
- Restart the app after granting permission

### "The app disappears from the list"
- This happens with development builds when Xcode cleans the build folder
- You'll need to re-add it from the new DerivedData location

## Security Note

This manual process is intentional and important. It ensures that:
- Only apps you explicitly trust can monitor keyboard input
- You have full control over which apps can interact with other apps
- Malicious apps cannot secretly gain these powerful permissions

While it's less convenient during development, this security model protects your privacy and security.