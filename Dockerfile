FROM jupyter/base-notebook

USER root

# Use mamba in base env for faster installs
RUN conda install -n base -c conda-forge mamba -y

# Set workdir and copy files
WORKDIR /home/jovyan
COPY --chown=jovyan:users . .
RUN chown -R jovyan:users /home/jovyan

# Install packages directly into base environment
USER jovyan
RUN mamba env update -n base -f environment.yml && conda clean --all -y

# OPTIONAL: Remove the default kernel and re-register it to avoid mismatches
RUN python -m ipykernel install --user --name=python3 --display-name "Python 3 (ipykernel)" --overwrite

EXPOSE 8888
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]
