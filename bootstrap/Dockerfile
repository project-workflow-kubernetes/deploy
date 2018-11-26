FROM python:3.6.6

COPY setup.py /bootstrap/
COPY requirements.txt /bootstrap/
COPY src/ /bootstrap/src/

RUN find . | grep -E "(__pycache__|\.pyc$)" | xargs rm -rf
RUN pip install -U -r bootstrap/requirements.txt
RUN pip install bootstrap/.
