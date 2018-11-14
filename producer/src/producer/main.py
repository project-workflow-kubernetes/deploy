import os
import json
import requests
import logging
import sys


def make_request(endpoint):
    data = {'old_path_data': 1, 'new_path_data': 2,
            'old_path_code': 3, 'new_path_code': 4}

    return requests.post('http://{}'.format(endpoint), json=data)


if __name__ == '__main__':
    endpoint = 'localhost:9999/run/' if len(sys.argv) == 1 else sys.argv[1]

    r = make_request(endpoint)
    print(r.status_code)
