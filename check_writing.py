# Description: Find common errors in text file for proper manuscript format
# Author: Russell Loewe
# Date: 2023


import re

def find_adjacent_duplicate_words_in_lines(text):
    lines = text.splitlines()
    duplicate_words = []

    for line_number, line in enumerate(lines, start=1):
        words = re.findall(r'\b\w+\b', line.lower())
        
        for i in range(len(words) - 1):
            if words[i] == words[i + 1]:
                duplicate_words.append((words[i], line_number))

    return duplicate_words
    
def remove_trailing_spaces(text):
    lines = text.split('\n')
    cleaned_lines = [line.rstrip() for line in lines]
    cleaned_text = '\n'.join(cleaned_lines)
    return cleaned_text

def remove_double_spaces(text):
    cleaned_text = re.sub(r'  ', ' ', text)
    return cleaned_text

def find_pattern(pattern, text):
    matches = re.finditer(pattern, text)
    # Return a list of tuples containing match positions and matched text
    return [(text.count('\n', 0, match.start()) + 1, match.group()) for match in matches]

def load_text_from_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            text = file.read()
        return text
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except Exception as e:
        print(f"Error: {e}")

def save_text_to_file(text, file_path):
    try:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(text)
        print(f"Text successfully saved to '{file_path}'.")
    except Exception as e:
        print(f"Error: {e}")

def main():

    # Load text
    file_path = '/path/to/filename.txt'
    original_text = load_text_from_file(file_path)
    
    # Make automate changes
    text = remove_trailing_spaces(original_text)
    text = remove_double_spaces(text)
    
    # Save changes
    if text != original_text:
        save_text_to_file(text, file_path)
    else:
        print("No automated changes made")

    # Find errors for manual review
    errors = {'punctuaction_after_quotes' : find_pattern(r'["”]\s?[\.\?\!]', text), # Check for punctation outside of quotes
              'spaces_before_quotes' :  find_pattern(r'\s+[”"]', text), # Check for before closing quotes
              'spaces_after_quotes' : find_pattern(r'[“"]\s+', text),
              'spaces_after_tabs' : find_pattern(r'\t\s+', text),
              'spaces_before_tabs' : find_pattern(r' \t', text)
    }
    
    # Print results
    for key, error in errors.items():
        if error:
            for position, matched_text in error:
                print(f"{key} Line: {position}, Matched Text: '{matched_text}'")
        else:
            print(f"No {key}")

    result = find_adjacent_duplicate_words_in_lines(text)
    # Print the duplicate words and the lines they occur on
    if result:
        for word, line_number in result:
            print(f"Duplicate on line {line_number}: {word}")

if __name__ == "__main__":
    main()
