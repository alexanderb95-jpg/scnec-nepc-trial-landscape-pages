#!/usr/bin/env python3
"""
Careful script to remove TNTT/DCR while preserving everything else.
"""

import re
import sys

def remove_tntt_dcr_carefully(text):
    """Remove TNTT and DCR sections without removing everything."""
    # Remove entire sections that are ONLY about TNTT or DCR
    # Look for section headers that mention TTNT or DCR
    patterns_to_remove = [
        # Sections about TTNT
        (r'##\s+.*[Tt]ime.*[Nn]ext.*[Tt]reatment.*?\n(?:[^#]|\n(?!##))*', ''),
        (r'###\s+.*TTNT.*?\n(?:[^#]|\n(?!###))*', ''),
        # Sections about DCR (but keep OS sections that might mention DCR in context)
        (r'##\s+.*[Dd]uration.*[Cc]omplete.*[Rr]esponse.*?\n(?:[^#]|\n(?!##))*', ''),
        (r'###\s+.*DCR.*Results.*?\n(?:[^#]|\n(?!###))*', ''),
    ]
    
    for pattern, replacement in patterns_to_remove:
        text = re.sub(pattern, replacement, text, flags=re.IGNORECASE | re.DOTALL)
    
    # Remove DCR/TTNT columns from descriptive tables (be more specific)
    # Only remove if the entire column header is about DCR/TTNT
    lines = text.split('\n')
    result_lines = []
    i = 0
    
    while i < len(lines):
        line = lines[i]
        
        # Check if this is a table row with DCR/TTNT columns
        if '|' in line and ('DCR' in line.upper() or 'TTNT' in line.upper() or 'Time to Next' in line.upper() or 'Duration.*Response' in line.upper()):
            # Check if it's a header row or data row
            if '**' in line or re.match(r'^\s*\|.*\*\*', line):
                # It's a header - remove DCR/TTNT columns
                parts = line.split('|')
                cleaned_parts = [p for p in parts if not re.search(r'DCR|TTNT|Time to Next|Duration.*Response', p, re.IGNORECASE)]
                if len(cleaned_parts) > 1:  # Keep the line if there are other columns
                    result_lines.append('|'.join(cleaned_parts))
                # Otherwise skip the line entirely
            else:
                # Data row - remove corresponding columns
                parts = line.split('|')
                # Find which columns to remove by checking header
                if i > 0 and '|' in lines[i-1]:
                    header_parts = lines[i-1].split('|')
                    keep_indices = [j for j, p in enumerate(header_parts) if not re.search(r'DCR|TTNT|Time to Next|Duration.*Response', p, re.IGNORECASE)]
                    if keep_indices:
                        cleaned_parts = [parts[j] if j < len(parts) else '' for j in keep_indices]
                        result_lines.append('|'.join(cleaned_parts))
        else:
            result_lines.append(line)
        i += 1
    
    return '\n'.join(result_lines)

def improve_inclusion_criteria(text):
    """Make inclusion criteria more readable."""
    # Find inclusion criteria and format better
    def format_criteria(match):
        full_match = match.group(0)
        # Add spacing after "Inclusion Criteria:"
        full_match = re.sub(r'(\*\*Inclusion Criteria:\*\*)\s*\n\s*-\s*', r'\1\n\n', full_match)
        # Ensure each criterion starts with bullet on new line
        full_match = re.sub(r'-\s+([^\n]+)\n(-)', r'- \1\n\2', full_match)
        return full_match
    
    text = re.sub(r'\*\*Inclusion Criteria:\*\*.*?(?=\n\*\*[^I]|\n##|\Z)', format_criteria, text, flags=re.DOTALL)
    
    return text

def clean_tables(text):
    """Clean table formatting."""
    # Remove excessive border characters but keep table structure
    text = re.sub(r'\+[-=]{3,}', '', text)
    # Keep simple table separators
    text = re.sub(r'\|[-=]{2,}', '|', text)
    
    # Remove completely empty table rows
    text = re.sub(r'^\s*\|\s*\|\s*\|\s*$', '', text, flags=re.MULTILINE)
    
    return text

def improve_readability(text):
    """General readability improvements."""
    # Fix population section formatting
    text = re.sub(
        r'\*\*N\s*=\s*(\d+)\s+patient-line observations\s*\(\s*(\d+)\s+unique patients\)',
        r'**N:** \1 patient-line observations (\2 unique patients)',
        text
    )
    
    # Remove excessive blank lines
    text = re.sub(r'\n{4,}', '\n\n', text)
    
    # Fix bullet points
    text = re.sub(r'^\s{4}-\s+', '- ', text, flags=re.MULTILINE)
    
    # Remove empty section headers
    text = re.sub(r'^##\s*$', '', text, flags=re.MULTILINE)
    text = re.sub(r'^###\s*$', '', text, flags=re.MULTILINE)
    
    return text

def main():
    input_file = '/Users/Alex/R/Question1_and_Question2_temp.md'
    output_file = '/Users/Alex/R/Question1_and_Question2_Final.md'
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_len = len(content)
        print(f"Original file length: {original_len} characters")
        
        print("Removing TNTT/DCR content (carefully)...")
        content = remove_tntt_dcr_carefully(content)
        
        print("Improving inclusion criteria...")
        content = improve_inclusion_criteria(content)
        
        print("Cleaning tables...")
        content = clean_tables(content)
        
        print("Improving readability...")
        content = improve_readability(content)
        
        # Final cleanup
        content = re.sub(r'\n{3,}', '\n\n', content)
        content = content.strip() + '\n'
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✓ Final document saved to: {output_file}")
        print(f"  Original: {original_len} characters")
        print(f"  Final: {len(content)} characters")
        print(f"  Reduction: {original_len - len(content)} characters ({100*(original_len-len(content))/original_len:.1f}%)")
        
        return output_file
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return None

if __name__ == '__main__':
    main()






