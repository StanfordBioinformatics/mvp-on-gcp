#!/usr/bin/env python

import os
import pdb
import sys
import argparse

def parse_args():

    parser = argparse.ArgumentParser()
    parser.add_argument(
                        '-i', '--input-file',
                        required=True,
                        type=str,
                        help='Path to input file')
    parser.add_argument(
                        '-t', '--table-file',
                        required=True,
                        type=str,
                        help='Path to output table')
    parser.add_argument(
                        '-o', '--gs-out-dir',
                        required=True,
                        type=str,
                        help='Google Storage path for task output objects')
    parser.add_argument(
                        '-s', '--suffix',
                        required=False,
                        type=str,
                        help='Suffix of task output objects on Google Storage')
    parser.add_argument(
                        '-c', '--schema',
                        required=False,
                        type=str,
                        help='Schema file for text-to-table operations')
    parser.add_argument(
                        '-e', '--series',
                        required=False,
                        type=str,
                        help='Arbitrary series label for text-to-table operations')
    return parser.parse_args()

def main():

    args = parse_args()
        
    input_file = args.input_file
    table_file = args.table_file
    gs_out_dir = args.gs_out_dir
    gs_out_suffix = args.suffix
    schema = args.schema
    series = args.series

    dirname = os.path.dirname(input_file)
    basename = os.path.basename(input_file)

    # Don't create TSV file if input is empty
    if os.stat(input_file).st_size == 0
        print "Input file is empty; skipping."
        sys.exit()

    # Write header
    out_fh = open(table_file, 'w')
    out_fh.write("--input INPUT\t--output OUTPUT\t--env SAMPLE_ID\t--env SCHEMA\t--env SERIES\n")
    
    with open(input_file, 'r') as in_fh:
        for line in in_fh:
            in_path = line.strip()
            path_elements = in_path.split('/')
            filename = path_elements[-1]
            out_path = "{0}/{1}.{2}".format(gs_out_dir, filename, gs_out_suffix)

            sample_id = filename.split('_')[0]
            out_fh.write("{}\t{}\t{}\t{}\t{}\n".format(in_path, out_path, sample_id, schema, series))
    out_fh.close()

if __name__ == "__main__":
    main()