# Use the official Jupyter base image
FROM jupyter/base-notebook

# Switch to root to install mamba
USER root

# Install mamba for faster dependency resolution
RUN conda install -n base -c conda-forge mamba -y

# Create cache and config dirs with correct permissions
RUN mkdir -p /home/jovyan/work/logs && \
    mkdir -p /home/jovyan/.config/matplotlib && \
    chown -R jovyan:users /home/jovyan/work /home/jovyan/.config

# Set matplotlib config path to a writable directory
ENV MPLCONFIGDIR=/home/jovyan/.config/matplotlib


# Switch back to jovyan for the rest of the build
USER jovyan

# Set working directory
WORKDIR /home/jovyan/work

# Copy environment file
COPY --chown=jovyan:users environment.yml .

# Create environment with strict channel priority
RUN mamba env update --file environment.yml && conda clean --all -y

# Register the environment as a Jupyter kernel
RUN conda run -n advanced1 python -m ipykernel install --user --name=advanced1 --display-name "Python (advanced1)"

# Copy all files into the container with correct ownership
COPY --chown=jovyan:users . .

# Expose default Jupyter port
EXPOSE 8888

# Start Jupyter in the correct environment
CMD ["conda", "run", "-n", "advanced1", "start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]
