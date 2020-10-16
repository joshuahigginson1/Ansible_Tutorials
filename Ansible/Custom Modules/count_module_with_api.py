""" A demo module for Ansible, using the ansible API."""

import os
import fnmatch

from ansible.module_utils.basic import AnsibleModule


def main():
    """ The main entrypoint for the module."""

    module = AnsibleModule(
        # Here, we specify the arguments that we are expecting.

        argument_spec=dict(ext=dict(type='str', required=True),
                           dir=dict(type='path', required=True),
                           )
    )

    directory = module.params['dir']
    extension = module.params['ext']

    # Walks the file system directory.
    # Count the number of files matching that directory.

    file_count = len([os.path.join(root, f)
                      for root, dirs, files in os.walk(directory)
                      for f in fnmatch.filter(files, extension)])

    module.exit_json(file_count=file_count,
                     dir=directory,
                     ext=extension,
                     changed=True,
                     )


if __name__ == "__main__":
    main()
