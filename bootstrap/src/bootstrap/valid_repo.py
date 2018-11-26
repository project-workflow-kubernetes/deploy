import os

def valid_repo(path):
    # must have `dependencies file`
    # must have `data''
    is_valid_repo = True
    if not is_valid_repo:
        raise Exception('The repository is not valid')
