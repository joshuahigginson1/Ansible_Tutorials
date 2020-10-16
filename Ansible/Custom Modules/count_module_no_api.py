"""
This Module returns the number of files of a given extension,
 within a particular directory.
"""

import fnmatch
import json
import os
import shlex
import sys


def main():
    """This function is the entrypoint for our module."""

    # Ansible stores arguments in a file, and passes that file into our module.
    with open(sys.argv[1], 'r') as argument_file:  # Open the module file.
        argument_context = argument_file.read()  # Read the file.
        arguments = shlex.split(argument_context)

        arguments_dict = {}

        # Create a dictionary of key value pairs from this ansible file.

        for argument in arguments:
            if '=' in argument:
                key, value = argument.split('=')  # Separates key value text.
                arguments_dict[key] = value

        # Error message.

        if 'dir' not in arguments_dict or 'ext' not in arguments_dict:
            print(json.dumps({
                'failed': True,
                'msg': 'Error, the directory and file extension are both required.'
            }))
            sys.exit(1)

        # Walks the file system directory.
        # Count the number of files matching that directory.

        file_count = len([os.path.join(root, f)
                          for root, dirs, files in
                          os.walk(arguments_dict['dir'])
                          for f in fnmatch.filter(files, arguments_dict['ext'])
                          ])
        print json.dumps({
            'dir': arguments_dict['dir'],
            'ext': arguments_dict['ext'],
            'file_count': file_count
        })

if __name__ == '__main__':
    main()
