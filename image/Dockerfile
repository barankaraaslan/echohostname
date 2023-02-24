FROM python:3.11.2-alpine3.17
ADD . . 
RUN pip3 install -r requirements.txt
ENTRYPOINT [ "uvicorn", "main:app", "--host", "0.0.0.0"]