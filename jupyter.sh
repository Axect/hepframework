echo "# Jupyter" >> ~/.bashrc
export DIRECTORY="$HOME/zlib/notebooks"
if [ ! -d "${DIRECTORY}" ]; 
then
	mkdir -p $HOME/zlib/notebooks
fi
echo 'export NOTEBOOK="$HOME/zlib/notebooks"' >> ~/.bashrc
echo 'alias initjupyter="docker run --name hepframejupyter -it -p 8888:8888 -v ${NOTEBOOK}:/opt/notebooks axect/hepframework:0.1"' >> ~/.bashrc
echo 'alias hepjupyter="docker start hepframejupyter"' >> ~/.bashrc
