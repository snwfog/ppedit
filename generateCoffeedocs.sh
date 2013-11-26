rm -rf docs
mkdir docs
mkdir docs_temp
docsDir=./docs
docsTempDir=./docs_temp

cp -r ppedit/coffee/src/* docs/
cd docs

function generateDocs()
{	
	for folder in $( ls -1p | grep / | sed 's/^\(.*\)/\1/')
	do
		echo $folder
		cd $folder
		generateDocs
		cd ..
	done
	docco *.coffee -o .	
	rm -rf *.coffee
}
generateDocs

