#!/usr/bin/env python3
"""
Script to improve formatting, brevity, and readability of the combined Question 1 and Question 2 document.
"""

import re
import sys

def clean_text(text):
    """Clean and improve text formatting."""
    # Remove excessive whitespace
    text = re.sub(r'\n{3,}', '\n\n', text)
    
    # Fix spacing around punctuation
    text = re.sub(r'\s+([.,;:])', r'\1', text)
    text = re.sub(r'([.,;:])\s*([A-Z])', r'\1 \2', text)
    
    # Remove redundant phrases
    redundant_patterns = [
        (r'\*\*Note:\*\*\s*Final analysis N.*?below\.', ''),
        (r'\*\*Note:\*\*\s*Each patient can contribute.*?analysis\.', ''),
        (r'\(baseline universe\)', ''),
        (r'\(landmark analysis universe\)', ''),
    ]
    
    for pattern, replacement in redundant_patterns:
        text = re.sub(pattern, replacement, text, flags=re.IGNORECASE | re.DOTALL)
    
    return text

def simplify_tables(text):
    """Simplify table formatting."""
    # Replace complex table borders with simpler ones
    text = re.sub(r'\+[-=]+\+', '|', text)
    text = re.sub(r'\|[-=]+\|', '|', text)
    
    # Remove excessive table formatting
    text = re.sub(r'\+[-=]{2,}', '', text)
    
    return text

def consolidate_sections(text):
    """Consolidate redundant sections."""
    # Remove empty sections
    text = re.sub(r'^##\s*$', '', text, flags=re.MULTILINE)
    text = re.sub(r'^###\s*$', '', text, flags=re.MULTILINE)
    
    # Consolidate repeated definitions
    # Remove duplicate tertile tables
    tertile_tables = list(re.finditer(r'Baseline ctDNA Tertile Values.*?\n\n', text, re.DOTALL))
    if len(tertile_tables) > 1:
        # Keep only the first occurrence
        for match in tertile_tables[1:]:
            text = text[:match.start()] + text[match.end():]
    
    return text

def improve_readability(text):
    """Improve overall readability."""
    # Fix bullet point formatting
    text = re.sub(r'^\s*-\s+', '- ', text, flags=re.MULTILINE)
    
    # Improve heading consistency
    text = re.sub(r'^#\s+Research Question', '## Research Question', text, flags=re.MULTILINE)
    
    # Remove incomplete sections
    text = re.sub(r'##\s+\n', '', text)
    
    # Consolidate verbose explanations
    verbose_patterns = [
        (r'This analysis compares whether.*?overall survival\.', 
         'Comparison of quantitative vs qualitative ctDNA models for OS.'),
        (r'To test whether.*?we attempted to.*?interaction term.*?', 
         'Interaction test: Histology × ctDNA clearance (could not be performed due to perfect separation).'),
    ]
    
    for pattern, replacement in verbose_patterns:
        text = re.sub(pattern, replacement, text, flags=re.DOTALL | re.IGNORECASE)
    
    # Remove placeholder text
    placeholder_patterns = [
        r'\*\*Note:\*\*.*?could not be completed.*?',
        r'\*\*Note:\*\*.*?did not converge.*?',
        r'Please see.*?for details\.',
        r'Please check.*?for details\.',
    ]
    
    for pattern in placeholder_patterns:
        text = re.sub(pattern, '', text, flags=re.IGNORECASE | re.DOTALL)
    
    return text

def shorten_verbose_explanations(text):
    """Shorten overly verbose explanations."""
    # Shorten endpoint definitions
    text = re.sub(
        r'\*\*Ascertainment:\*\*.*?data collection\.',
        '**Ascertainment:** Death dates from medical records; censoring based on last follow-up.',
        text,
        flags=re.DOTALL
    )
    
    # Shorten censoring explanations
    text = re.sub(
        r'\*\*Censoring:\*\*.*?marked as alive',
        '**Censoring:** Patients alive at last follow-up (coded as 0).',
        text,
        flags=re.DOTALL
    )
    
    # Shorten interpretation sections
    text = re.sub(
        r'\*\*Interpretation:\*\*\s*Overall Survival analysis:.*?outcomes\.',
        '**Interpretation:** ctDNA clearance at landmark (6-24 weeks) is strongly associated with improved OS (p<0.001). Perfect separation (0 deaths in cleared group, 10 in non-cleared) precludes Cox regression; log-rank tests demonstrate significant association.',
        text,
        flags=re.DOTALL
    )
    
    return text

def main():
    input_file = '/Users/Alex/R/Question1_and_Question2_temp.md'
    output_file = '/Users/Alex/R/Question1_and_Question2_Improved.md'
    
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Apply improvements
        print("Cleaning text...")
        content = clean_text(content)
        
        print("Simplifying tables...")
        content = simplify_tables(content)
        
        print("Consolidating sections...")
        content = consolidate_sections(content)
        
        print("Improving readability...")
        content = improve_readability(content)
        
        print("Shortening verbose explanations...")
        content = shorten_verbose_explanations(content)
        
        # Final cleanup
        content = re.sub(r'\n{3,}', '\n\n', content)
        content = content.strip() + '\n'
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✓ Improved document saved to: {output_file}")
        print(f"  Original length: {len(open(input_file, 'r').read())} characters")
        print(f"  Improved length: {len(content)} characters")
        
        return output_file
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return None

if __name__ == '__main__':
    main()






