import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    replacements = [
        (r'const Color\(0xFF00FFA3\)', r'Theme.of(context).colorScheme.primary'),
        (r'Color\(0xFF00FFA3\)', r'Theme.of(context).colorScheme.primary'),
        (r'const Color\(0xFF0E1415\)', r'Theme.of(context).colorScheme.surface'),
        (r'Color\(0xFF0E1415\)', r'Theme.of(context).colorScheme.surface'),
        (r'const Color\(0xFF131D1F\)', r'Theme.of(context).colorScheme.surface'),
        (r'Color\(0xFF131D1F\)', r'Theme.of(context).colorScheme.surface'),
        (r'const Color\(0xFF060B0C\)', r'Theme.of(context).scaffoldBackgroundColor'),
        (r'Color\(0xFF060B0C\)', r'Theme.of(context).scaffoldBackgroundColor'),
        (r'const Color\(0xFF1A1F21\)', r'Theme.of(context).colorScheme.surface'),
        (r'Color\(0xFF1A1F21\)', r'Theme.of(context).colorScheme.surface'),
        (r'const Color\(0xFF1A2426\)', r'Theme.of(context).colorScheme.surface'),
        (r'Color\(0xFF1A2426\)', r'Theme.of(context).colorScheme.surface'),
        (r'Colors\.white', r'Theme.of(context).colorScheme.onSurface'),
        (r'Colors\.white70', r'Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)'),
        (r'Colors\.white60', r'Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)'),
        (r'Colors\.white54', r'Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54)'),
        (r'Colors\.white30', r'Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)'),
        (r'Colors\.white12', r'Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)'),
        (r'Colors\.white10', r'Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)'),
    ]

    new_content = content
    for pattern, repl in replacements:
        new_content = re.sub(pattern, repl, new_content)

    # We also need to remove 'const ' when it precedes a Theme.of(context) call, otherwise it won't compile
    # A generic regex to remove const from parent widgets that now contain Theme.of(context)
    new_content = re.sub(r'const\s+([A-Za-z0-9_]+)\([^)]*Theme\.of\(context\)[^)]*\)', r'\1( /* removed const */', new_content)
    # A more robust regex: remove 'const ' if the line has Theme.of(context)
    lines = new_content.split('\n')
    for i, line in enumerate(lines):
        if 'Theme.of(context)' in line and 'const ' in line:
            # specifically look for const Icon, const Text, const TextStyle, const BoxDecoration
            lines[i] = re.sub(r'const\s+(Icon|Text|TextStyle|BoxDecoration|Border|Shadow|BoxShadow|Row|Column|Padding|Divider|SizedBox)', r'\1', line)
            
            # If there's just a generic const before a bracket that spans multiple lines, we might miss it, 
            # but this covers 95% of cases.

    new_content = '\n'.join(lines)

    if content != new_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, dirs, files in os.walk('d:/proyectos/MobileLockAI/MobileLock_Flutter/lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
