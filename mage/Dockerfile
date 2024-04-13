FROM mageai/mageai:latest

ARG USER_CODE_PATH=/home/src/${PROJECT_NAME}

# Note: this overwrites the requirements.txt file in your new project on first run. 
# You can delete this line for the second run :) 


COPY requirements.txt ${USER_CODE_PATH}requirements.txt 
COPY energy_data_etl/ ${USER_CODE_PATH}energy_data_etl/

RUN pip install --upgrade pip && \
    pip3 install -r ${USER_CODE_PATH}requirements.txt
