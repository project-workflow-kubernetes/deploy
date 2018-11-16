# deploy

## Deploy it
```bash
make up
```
1. Check if you have necessary requirements and ports are free
2. Creates `workflow` and `argo` namespaces
3. Install 3 minios in `workflow` namespace (`minio`, `minio-tmp`, `minio-workflow`) and port-foward them to `9030`, `9060`, `9090`
4. Install `argo` in `argo` namespace in port 80
5. Install `workflow-service` in port 8000

## Shutdown
```bash
make down
```


## Run job (WIP)
It will send a POST request to `http://localhost:8000` with information to run the job (old_code_url, new_code_url, new_data_url, old_data_url, job_name, run_id, src)
```bash
python producer/src/producer main.py
```
