import os
import argparse
import shutil

from minio import Minio
from git import Repo

import setting as s
from valid_repo import valid_repo


minioPersistent = Minio(s.PERSISTENT_ADDR,
                        access_key=s.ACCESS_KEY,
                        secret_key=s.SECRET_KEY,
                        secure=False)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("job_name", help="job_name", type=str)
    parser.add_argument("code_folder", help="code_folder", type=str)
    parser.add_argument("data_folder", help="data_folder", type=str)
    parser.add_argument("job_url", help="job url", type=str)
    args = parser.parse_args()
    job_name = args.job_name
    job_url = args.job_url
    code_folder = args.code_folder
    data_folder = args.data_folder

    local_path = os.path.join(s.RESOURCES_PATH, job_name)
    data_path = os.path.join(local_path, data_folder)
    code_path = os.path.join(local_path, code_folder)

    if not os.path.exists(local_path):
        os.makedirs(local_path)
    else:
        shutil.rmtree(local_path)

    repo = Repo.clone_from(job_url, local_path)
    valid_repo(local_path)
    commit_hash = repo.commit().hexsha
    commit_time = repo.commit().committed_datetime.strftime("%Y-%m-%d %H:%M:%S")

    with open(os.path.join(local_path, 'commit_time.txt'), "w") as f:
        f.write(commit_time)

    # TODO: check if the files are in dependencies.yaml
    data_files = [f for f in os.listdir(data_path) if os.path.isfile(os.path.join(data_path, f))]
    data_minio_files = [os.path.join(commit_hash, s.FOLDER_DATA, f) for f in data_files]
    data_local_files = [os.path.join(data_path, f) for f in data_files]

    code_files = os.listdir(code_path)
    code_minio_files = [os.path.join(commit_hash, s.FOLDER_CODE, f) for f in code_files]

    local_files = [os.path.join(code_path, f) for f in code_files] + [os.path.join(data_path, f) for f in data_files]
    minio_files = code_minio_files + data_minio_files

    files = dict(zip(local_files, minio_files))
    files[os.path.join(local_path, 'dependencies.yaml')] = os.path.join(commit_hash, 'dependencies.yaml')
    files[os.path.join(local_path, 'commit_time.txt')] = os.path.join(commit_hash, 'commit_time.txt')

    minioPersistent.make_bucket(job_name)

    for f in files.keys():
        minioPersistent.fput_object(job_name, files[f], f)

    shutil.rmtree(local_path)
