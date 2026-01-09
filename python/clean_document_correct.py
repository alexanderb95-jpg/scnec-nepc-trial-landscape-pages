#!/usr/bin/env python3
"""
Correct script: Keep Question 1 DCR, remove DCR/TTNT only from Question 2, improve formatting.
"""

import re
import sys

def split_questions(text):
    """Split text into Question 1 and Question 2 sections."""
    # Find where Question 2 starts
    q2_pattern = r'(#.*Question 2|##.*Question 2|Research Question 2)'
    match = re.search(q2_pattern, text, re.IGNORECASE)
    
    if match:
        q1_text = text[:match.start()]
        q2_text = text[match.start():]
        return q1_text, q2_text
    else:
        # If no clear split, assume all is Question 1
        return text, ""

def remove_tntt_dcr_from_q2(text):
    """Remove TNTT and DCR sections from Question 2 only."""
    # Remove sections that are specifically about TTNT or DCR in Q2
    # But keep OS sections
    
    # Remove TTNT sections
    text = re.sub(r'##\s+.*[Tt]ime.*[Nn]ext.*[Tt]reatment.*?\n.*?(?=\n##|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'###\s+.*TTNT.*?\n.*?(?=\n##|\n###|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    
    # Remove DCR sections (but be careful not to remove OS)
    text = re.sub(r'##\s+.*[Dd]uration.*[Cc]omplete.*[Rr]esponse.*?\n.*?(?=\n##|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    text = re.sub(r'###\s+.*DCR.*Results.*?\n.*?(?=\n##|\n###|\Z)', '', text, flags=re.DOTALL | re.IGNORECASE)
    
    # Remove DCR/TTNT from table headers and columns in Q2
    lines = text.split('\n')
    result_lines = []
    in_table = False
    header_line_idx = -1
    
    for i, line in enumerate(lines):
        if '|' in line and ('DCR' in line.upper() or 'TTNT' in line.upper() or 'Time to Next' in line.upper()):
            # This might be a table with DCR/TTNT
            if '**' in line or re.match(r'^\s*\|.*\*\*', line):
                # It's a header - check if we should remove columns
                header_line_idx = i
                parts = line.split('|')
                # Remove DCR/TTNT columns
                cleaned_parts = []
                for part in parts:
                    if not re.search(r'DCR|TTNT|Time to Next|Duration.*Response', part, re.IGNORECASE):
                        cleaned_parts.append(part)
                if len(cleaned_parts) > 1:
                    result_lines.append('|'.join(cleaned_parts))
                # Skip the original line
                continue
            elif header_line_idx >= 0:
                # This is a data row following a header we modified
                header_parts = lines[header_line_idx].split('|')
                data_parts = line.split('|')
                keep_indices = [j for j, p in enumerate(header_parts) if not re.search(r'DCR|TTNT|Time to Next|Duration.*Response', p, re.IGNORECASE)]
                if keep_indices and len(keep_indices) <= len(data_parts):
                    cleaned_parts = [data_parts[j] if j < len(data_parts) else '' for j in keep_indices]
                    result_lines.append('|'.join(cleaned_parts))
                continue
        
        result_lines.append(line)
        if '|' not in line:
            header_line_idx = -1
    
    return '\n'.join(result_lines)

def improve_inclusion_criteria(text):
    """Make inclusion criteria more readable."""
    def format_criteria(match):
        full = match.group(0)
        # Add spacing
        full = re.sub(r'(\*\*Inclusion Criteria:\*\*)\s*\n\s*-\s*', r'\1\n\n', full)
        # Fix bullet spacing
        full = re.sub(r'-\s+([^\n]+)\n(-)', r'- \1\n\2', full)
        return full
    
    text = re.sub(r'\*\*Inclusion Criteria:\*\*.*?(?=\n\*\*[^I]|\n##|\Z)', format_criteria, text, flags=re.DOTALL)
    return text

def clean_tables(text):
    """Clean table formatting."""
    # Remove excessive borders
    text = re.sub(r'\+[-=]{3,}', '', text)
    text = re.sub(r'\|[-=]{2,}', '|', text)
    # Remove empty rows
    text = re.sub(r'^\s*\|\s*\|\s*\|\s*$', '', text, flags=re.MULTILINE)
    return text

def improve_readability(text):
    """General readability improvements."""
    # Fix N formatting
    text = re.sub(
        r'\*\*N\s*=\s*(\d+)\s+patient-line observations\s*\(\s*(\d+)\s+unique patients\)',
        r'**N:** \1 patient-line observations (\2 unique patients)',
        text
    )
    # Remove excessive blank lines
    text = re.sub(r'\n{4,}', '\n\n', text)
    # Fix bullets
    text = re.sub(r'^\s{4}-\s+', '- ', text, flags=re.MULTILINE)
    # Remove empty headers
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
        print(f"Original: {original_len} characters")
        
        # Split into Q1 and Q2
        q1_text, q2_text = split_questions(content)
        print(f"Question 1 length: {len(q1_text)}")
        print(f"Question 2 length: {len(q2_text)}")
        
        # Process Q2 only (remove DCR/TTNT)
        if q2_text:
            print("Removing TNTT/DCR from Question 2 only...")
            q2_text = remove_tntt_dcr_from_q2(q2_text)
        
        # Combine back
        content = q1_text + q2_text
        
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
        
        print(f"✓ Final document: {len(content)} characters")
        print(f"  Saved to: {output_file}")
        
        return output_file
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return None

if __name__ == '__main__':
    main()






