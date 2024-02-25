FROM python:3.8

RUN pip install explainerdashboard

COPY generate_dashboard.py ./
COPY run_dashboard.py ./

RUN python generate_dashboard.py

EXPOSE 9050
CMD ["python", "./run_dashboard.py"]