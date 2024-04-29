FROM python:latest

EXPOSE 8080
WORKDIR app/

COPY . ./

RUN pip install -r requirements.txt

ENTRYPOINT ["python"]

CMD ["app.py"]