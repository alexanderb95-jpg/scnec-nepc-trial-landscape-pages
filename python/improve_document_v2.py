#!/usr/bin/env python3
"""
Script to improve formatting while keeping figures, removing TNTT/DCR, and improving readability.
"""

import re
import sys

def remove_tntt_dcr_sections(text):
    """Remove all TNTT and DCR related content."""
    # Remove sections mentioning TNTT or DCR
    patterns = [
        r'##.*[Tt]ime.*[Nn]ext.*[Tt]reatment.*\n.*?(?=##|\Z)',
        r'##.*[Dd]uration.*[Cc]omplete.*[Rr]esponse.*\n.*?(?=##|\Z)',
        r'##.*DCR.*\n.*?(?=##|\Z)',
        r'##.*TTNT.*\n.*?(?=##|\Z)',
        r'.*TTNT.*\n',
        r'.*DCR.*[Ee]vents.*\n',
        r'.*Time to Next Treatment.*\n',
        r'.*Duration of Complete Response.*\n',
        r'DCR Median.*\n',
        r'1-year.*DCR.*\n',
    ]
    
    for pattern in patterns:
        text = re.sub(pattern, '', text, flags=re.IGNORECASE | re.MULTILINE | re.DOTALL)
    
    # Remove table columns related to DCR/TTNT
    text = re.sub(r'\|\s*DCR.*?\||\|\s*TTNT.*?\||\|\s*Time to Next.*?\||\|\s*Duration.*Response.*?\|', '', text, flags=re.IGNORECASE)
    
    # Remove references in descriptive tables
    text = re.sub(r'DCR.*Events.*?\|', '', text, flags=re.IGNORECASE | re.MULTILINE)
    text = re.sub(r'Median DCR.*?\|', '', text, flags=re.IGNORECASE | re.MULTILINE)
    text = re.sub(r'1-year DCR.*?\|', '', text, flags=re.IGNORECASE | re.MULTILINE)
    
    return text

def improve_inclusion_criteria(text):
    """Make inclusion criteria easier to read."""
    # Find and reformat inclusion criteria sections
    inclusion_pattern = r'\*\*Inclusion Criteria:\*\*\s*\n\s*-\s*'
    
    def format_criteria(match):
        criteria_text = match.group(0)
        # Convert to bullet list with better spacing
        criteria_text = re.sub(r'-\s+', '\n- ', criteria_text)
        criteria_text = re.sub(r'\n\s*\n', '\n', criteria_text)
        return criteria_text
    
    text = re.sub(inclusion_pattern, '**Inclusion Criteria:**\n\n', text)
    
    # Ensure proper bullet formatting
    text = re.sub(r'^\s*-\s+', '- ', text, flags=re.MULTILINE)
    
    # Add spacing around criteria
    text = re.sub(r'(\*\*Inclusion Criteria:\*\*)\n', r'\1\n\n', text)
    text = re.sub(r'(-\s+[^\n]+)\n(-)', r'\1\n\2', text)
    
    return text

def clean_tables(text):
    """Format tables cleaner."""
    # Fix table alignment issues
    text = re.sub(r'\|[-=]+\|', '|', text)
    text = re.sub(r'\+[-=]+\+', '|', text)
    
    # Remove excessive table borders
    text = re.sub(r'\+[-=]{3,}', '', text)
    
    # Fix table spacing
    text = re.sub(r'\n\s*\|\s*\n\s*\|', '\n|', text)
    
    # Clean up table headers
    text = re.sub(r'\|\s*\*\*([^*]+)\*\*\s*\|', r'| **\1** |', text)
    
    # Remove empty table rows
    text = re.sub(r'\|\s*\|\s*\|\s*\n', '', text)
    
    return text

def improve_readability(text):
    """General readability improvements."""
    # Fix spacing
    text = re.sub(r'\n{4,}', '\n\n', text)
    text = re.sub(r'  +', ' ', text)
    
    # Improve section headers
    text = re.sub(r'^##\s+$', '', text, flags=re.MULTILINE)
    
    # Fix bullet points
    text = re.sub(r'^\s*-\s+', '- ', text, flags=re.MULTILINE)
    
    # Improve population studied section
    text = re.sub(
        r'\*\*Universe:\*\*\s*([^\n]+)',
        r'**Universe:** \1',
        text
    )
    
    text = re.sub(
        r'\*\*N\s*=\s*(\d+)\s+patient-line observations\s*\(\s*(\d+)\s+unique patients\)',
        r'**N:** \1 patient-line observations (\2 unique patients)',
        text
    )
    
    # Clean up notes
    text = re.sub(r'\*\*Note:\*\*\s*\n', '**Note:** ', text)
    
    return text

def keep_figures(text):
    """Ensure figures are preserved."""
    # Keep all image references
    # Images should already be in the markdown from pandoc
    return text

def main():
    input_file = '/Users/Alex/R/Question1_and_Question2_temp.md'
    output_file = '/Users/Alex/R/Question1_and_Question2_Cleaned.md'
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        print("Removing TNTT/DCR content...")
        content = remove_tntt_dcr_sections(content)
        
        print("Improving inclusion criteria readability...")
        content = improve_inclusion_criteria(content)
        
        print("Cleaning table formatting...")
        content = clean_tables(content)
        
        print("Improving general readability...")
        content = improve_readability(content)
        
        # Final cleanup
        content = re.sub(r'\n{3,}', '\n\n', content)
        content = content.strip() + '\n'
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✓ Cleaned document saved to: {output_file}")
        
        return output_file
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return None

if __name__ == '__main__':
    main()






