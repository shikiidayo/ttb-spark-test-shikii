import string

uppercase_alphabet = list(string.ascii_uppercase)

def simpleCypher(input_string, key):
    input_string = input_string.upper()
    output_string = ""
    for char in input_string:
        char_index = uppercase_alphabet.index(char)
        output_string = output_string + uppercase_alphabet[(char_index - key)]

    return output_string

test = simpleCypher('VTAOG',2 )

print(test)