#!/usr/bin/python3

import argparse

instructions = {
    "brzr": '0',
    "ji": '1',
    "ld": '2',
    "st": '3',
    "addi": '4',
    "push": '5',
    "pop": '6',
    "mov": '7',
    "not": '8',
    "and": '9',
    "or": 'a',
    "xor": 'b',
    "add": 'c',
    "sub": 'd',
    "slr": 'e',
    "srr": 'f'
}

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input_filename')
    parser.add_argument('output_filename')

    args = parser.parse_args()

    input_filename = args.input_filename
    output_filename = args.output_filename
    
    with open(input_filename, 'r') as input_file, open(output_filename, 'w') as output_file:
        for line in input_file:
            if (line.isspace()):
                continue

            line = line.strip().split(" ")
            inst = instructions[line[0]]
            line.pop(0)

            if (len(line) == 1):
                inst += f"{hex(int(line[0][1:] + '00' if line[0][0] == 'r' else line[0]) & ((1 << 4) - 1))[2:]}"
                    
            elif (len(line) == 2):
                hi = line[0]
                low = line[1]

                if (hi[0] == 'r'):
                    hi = hi[1:]

                if (low[0] == 'r'):
                    low = low[1:]

                hi = int(hi)
                low = int(low)
                inst += f"{hex((hi << 2 | low))[2:]}"

            output_file.write(inst)
            output_file.write("\n")
