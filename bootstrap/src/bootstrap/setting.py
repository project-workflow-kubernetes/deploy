import os

RESOURCES_PATH = os.path.join(os.path.abspath(os.path.join(__file__, '../../../')), 'resources')

PERSISTENT_ADDR = 'docker.for.mac.localhost:9060' if os.environ.get('OUTSIDE_SYSTEM', None) == 'Darwin' else 'localhost:9060' # TODO: better way to do it
ACCESS_KEY = os.environ['MINIO_ACCESS_KEY'] if os.environ.get('MINIO_ACCESS_KEY', None) else 'minio'
SECRET_KEY = os.environ['MINIO_SECRET_KEY'] if os.environ.get('MINIO_SECRET_KEY', None) else 'minio1234'
FOLDER_DATA = 'data'
FOLDER_CODE = 'code'
