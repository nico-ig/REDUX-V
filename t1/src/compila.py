import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input_filename')
    parser.add_argument('output_filename')

    args = parser.parse_args()

    input_filename = args.input_filename
    output_filename = args.output_filename
    
    with open(input_filename, 'r') as input_file, open(output_filename, 'wb') as output_file:
        for line in input_file:
            byte = int(line.strip(), 2)
            output_file.write(bytes([byte]))

