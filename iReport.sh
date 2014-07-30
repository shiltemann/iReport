#!/bin/bash
repositorypath="/mnt/galaxyTools/shed_tools/toolshed.nbic.nl/repos/saskia-hiltemann/ireport/71dc132e9bb2/ireport"  # TODO: dependency
source "${repositorypath}/createHTML.sh"

echo "allparams: $@"
function usage() { echo "Oops!"; }


# set some defaults


set -- `getopt -n$0 -u -a --longoptions="ifusepath: galaxypath: tab: item: htmlout: label: toolpath: minwidth: coverimage:" "h:" "$@"` || usage
[ $# -eq 0 ] && usage

while [ $# -gt 0 ]
do
    case "$1" in
       	--toolpath)      		repositorypath=$2;shift;;  
		--galaxypath)			galaxypath=$2;shift;; 
		--minwidth)				minwidth=$2;shift;; 
		--tab)					tabs+=",$2";shift;;
		--item)					items+=",$2";shift;;
		--htmlout)				htmlout=$2;shift;;
		--label)				title="$@";shift;;
		--coverimage)			coverimage=$2;shift;;
        -h)        	shift;;
		--)        	shift;break;;
        -*)        	usage;;
        *)         	break;;
    esac
    shift
done


mkdir $galaxypath

tabs=${tabs//,/ }; tabs=${tabs/ /}
items=${items//,/ }; items=${items/ /}
title=${title//--/}
title=${title//label/}

reportname=${title// /}

echo -e "\n"
echo -e "title:      $title"
echo -e "tabs:       $tabs"
echo -e "items:      $items"
echo -e "htmlout:    $htmlout"
echo -e "coverimage: $coverimage"
echo -e "\n"

for i in $tabs
do 
	echo "tabname: $i" 
done

coverimage=${coverimage:1}
echo -e "coverimage2: $coverimage"

#if no coverimage provided, use default EMC logo
if [[ -z $coverimage ]] 
then
	cp $repositorypath/intro.jpg ${galaxypath}/intro.jpg
	coverimage="intro.jpg"
fi
echo -e "coverimage3: $coverimage"

## Copy supporting files to output directory
cp ${repositorypath}/jquery.dataTables.css ${galaxypath}/jquery.dataTables.css
cp ${repositorypath}/jquery.dataTables.js ${galaxypath}/jquery.dataTables.js
cp -R ${repositorypath}/iframe-resizer/ ${galaxypath}/iframe-resizer/
cp -R ${repositorypath}/DataTables-1.9.4/ ${galaxypath}/DataTables-1.9.4/
cp ${repositorypath}/jquery.zoom.js ${galaxypath}/jquery.zoom.js
cp ${repositorypath}/jquery-ui.css ${galaxypath}/jquery-ui.css
cp ${repositorypath}/jquery-1.10.2.js ${galaxypath}/jquery-1.10.2.js
cp ${repositorypath}/jquery-ui.js ${galaxypath}/jquery-ui.js

echo "done copying resource files"
ls ${galaxypath}


## Create cover HTML page
makeIntroPage "$title" $coverimage "report.html" $htmlout iReport_${reportname}.zip

## Create copy of cover page for downloadable version
makeIntroPage "$title" $coverimage "report.html" coverpage.html iReport_${reportname}.zip
cp coverpage.html ${galaxypath}/coverpage.html

## Create Report page with tabs
createMainPage ${galaxypath}/report.html "$tabs" "$items" $minwidth


## Create zip file of this iReport for download by user
wd=`pwd`
cd ${galaxypath}
zip -r iReport_${reportname} .
cd $wd

