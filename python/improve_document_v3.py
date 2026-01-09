#!/usr/bin/env python3
"""
Improved script to process the document: remove TNTT/DCR, keep figures, improve formatting.
"""

import re
import sys

def remove_tntt_dcr(text):
    """Remove TNTT and DCR content more carefully."""
    # Remove entire sections about TNTT/DCR
    text = re.sub(r'##.*[Tt]ime.*[Nn]ext.*[Tt]reatment.*?(?=\n##|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'##.*[Dd]uration.*[Cc]omplete.*[Rr]esponse.*?(?=\n##|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'###.*TTNT.*?(?=\n##|\n###|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'###.*DCR.*?(?=\n##|\n###|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    
    # Remove DCR/TTNT from table headers and rows
    lines = text.split('\n')
    cleaned_lines = []
    skip_next = False
    
    for i, line in enumerate(lines):
        # Skip lines with DCR/TTNT in headers
        if re.search(r'DCR|TTNT|Time to Next|Duration.*Response', line, re.IGNORECASE) and '|' in line:
            # Check if it's a table header or data row
            if '**' in line or re.match(r'^\s*\|.*\|', line):
                continue  # Skip this line
        cleaned_lines.append(line)
    
    text = '\n'.join(cleaned_lines)
    
    # Remove DCR/TTNT columns from descriptive tables
    text = re.sub(r'\|\s*DCR[^|]*\||\|\s*TTNT[^|]*\||\|\s*Time to Next[^|]*\||\|\s*Duration[^|]*Response[^|]*\|', '', text, flags=re.IGNORECASE)
    
    return text

def improve_inclusion_criteria(text):
    """Make inclusion criteria more readable."""
    # Pattern to find inclusion criteria sections
    def format_inclusion(match):
        section = match.group(0)
        # Ensure proper spacing
        section = re.sub(r'\*\*Inclusion Criteria:\*\*\s*\n\s*-\s*', '**Inclusion Criteria:**\n\n', section)
        # Ensure each criterion is on its own line with proper bullet
        section = re.sub(r'-\s+([^\n]+)\n(-)', r'- \1\n\2', section)
        section = re.sub(r'-\s+([^\n]+)\n([A-Z])', r'- \1\n\n\2', section)
        return section
    
    text = re.sub(r'\*\*Inclusion Criteria:\*\*.*?(?=\n\*\*|\n##|\Z)', format_inclusion, text, flags=re.DOTALL)
    
    return text

def clean_tables(text):
    """Clean up table formatting."""
    # Remove excessive border characters
    text = re.sub(r'\+[-=]{2,}', '', text)
    text = re.sub(r'\|[-=]{2,}', '|', text)
    
    # Fix table spacing
    text = re.sub(r'\n\s*\|\s*\n\s*\|', '\n|', text)
    
    # Remove empty table rows
    text = re.sub(r'^\s*\|\s*\|\s*\|\s*$', '', text, flags=re.MULTILINE)
    
    # Clean up alignment markers
    text = re.sub(r':-+:', '---', text)
    text = re.sub(r':-+', '---', text)
    
    return text

def improve_readability(text):
    """General readability improvements."""
    # Fix population studied section
    text = re.sub(
        r'\*\*N\s*=\s*(\d+)\s+patient-line observations\s*\(\s*(\d+)\s+unique patients\)',
        r'**N:** \1 patient-line observations (\2 unique patients)',
        text
    )
    
    # Improve spacing
    text = re.sub(r'\n{4,}', '\n\n', text)
    text = re.sub(r'  +', ' ', text)
    
    # Fix bullet points
    text = re.sub(r'^\s*-\s+', '- ', text, flags=re.MULTILINE)
    
    # Remove empty sections
    text = re.sub(r'^##\s*$', '', text, flags=re.MULTILINE)
    text = re.sub(r'^###\s*$', '', text, flags=re.MULTILINE)
    
    return text

def main():
    input_file = '/Users/Alex/R/Question1_and_Question2_temp.md'
    output_file = '/Users/Alex/R/Question1_and_Question2_Final.md'
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        print(f"Original file length: {len(content)} characters")
        
        print("Removing TNTT/DCR content...")
        content = remove_tntt_dcr(content)
        
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
        print(f"  Final length: {len(content)} characters")
        
        return output_file
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return None

if __name__ == '__main__':
    main()






