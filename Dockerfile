FROM jupyter/base-notebook

USER root

# Install mamba
RUN conda install -n base -c conda-forge mamba -y

# Ensure matplotlib config dir is writable
RUN mkdir -p /home/jovyan/.config/matplotlib && \
    chown -R jovyan:users /home/jovyan/.config

ENV MPLCONFIGDIR=/home/jovyan/.config/matplotlib

# Set working directory and copy files
WORKDIR /home/jovyan/work
COPY --chown=jovyan:users . .

USER jovyan

# Update the base env (do not create a new env)
RUN mamba env update -n base -f environment.yml && conda clean --all -y

EXPOSE 8888
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]
