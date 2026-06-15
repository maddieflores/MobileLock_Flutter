import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find widgets that have const and contain Color(0xFF00FFA3)
    widgets = ['Icon', 'TextStyle', 'BoxDecoration', 'Shadow', 'BorderSide', 'CircularProgressIndicator', 'Text', 'Padding', 'Expanded', 'Center', 'Row', 'Column', 'Container']
    
    for w in widgets:
        # Regex to find: const Widget( ... Color(...) ... )
        # This is hard because of nested parenthesis. 
        # A simpler way: just remove "const " from lines that contain the color hex
        pass
        
    lines = content.split('\n')
    for i in range(len(lines)):
        if '0xFF00FFA3' in lines[i] or '0xFF0E1415' in lines[i] or '0xFF131D1F' in lines[i] or '0xFF060B0C' in lines[i] or '0xFF1A1F21' in lines[i] or '0xFF1A2426' in lines[i]:
            lines[i] = lines[i].replace('const ', '')
            # Also check the previous line just in case it was a multi-line const like `const Text(\n ... Color(...)`
            if i > 0 and 'const ' in lines[i-1] and not any(kw in lines[i-1] for kw in ['class ', 'final ', 'static ']):
                lines[i-1] = lines[i-1].replace('const ', '')
            if i > 1 and 'const ' in lines[i-2] and not any(kw in lines[i-2] for kw in ['class ', 'final ', 'static ']):
                lines[i-2] = lines[i-2].replace('const ', '')

    new_content = '\n'.join(lines)
    
    # Now replace the color definitions
    new_content = new_content.replace('Color(0xFF00FFA3)', 'Theme.of(context).colorScheme.primary')
    new_content = new_content.replace('Color(0xFF0E1415)', 'Theme.of(context).colorScheme.surface')
    new_content = new_content.replace('Color(0xFF131D1F)', 'Theme.of(context).colorScheme.surface')
    new_content = new_content.replace('Color(0xFF060B0C)', 'Theme.of(context).scaffoldBackgroundColor')
    new_content = new_content.replace('Color(0xFF1A1F21)', 'Theme.of(context).colorScheme.surface')
    new_content = new_content.replace('Color(0xFF1A2426)', 'Theme.of(context).colorScheme.surface')

    if content != new_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, dirs, files in os.walk('d:/proyectos/MobileLockAI/MobileLock_Flutter/lib/src/pages'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
