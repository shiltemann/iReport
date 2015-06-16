#!/bin/bash


echo "allparams: $@"
function usage() { echo "Oops!"; }


# set some defaults

gbcount=0
set -- `getopt -n$0 -u -a --longoptions="ifusepath: galaxypath: tab: item: genomebrowsertrack: newgb: htmlout: label: toolpath: minwidth: coverimage:" "h:" "$@"` || usage
[ $# -eq 0 ] && usage

while [ $# -gt 0 ]
do
    case "$1" in
       	--toolpath)				repositorypath=$2;shift;;
		--galaxypath)			galaxypath=$2;shift;;
		--minwidth)				minwidth=$2;shift;; 
		--tab)					tabs+=",$2";shift;;
		--item)					items+=",$2";shift;;
		--newgb)				gbcount=$[$gbcount+1];shift;;
		--genomebrowsertrack)	gbtracks+=",${gbcount}:$2";shift;;
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

source "${repositorypath}/createHTML.sh"
mkdir $galaxypath

#tabs=${tabs//,/ }; tabs=${tabs/ /}
#tabs=${tabs//==dollar==/$}
#tabs=${tabs//==braceopen==/(}
#tabs=${tabs//==braceclose==/)}
gbtracks=${gbtracks:1}
items=${items//,/ }; items=${items/ /}

title=${title//--/}
title=${title//label/}
title=${title// /}

echo -e "title:      $title"
echo -n "$title" > tmpfileb64
title=`base64 -d tmpfileb64`
echo -e "title decoded:      $title"

#title=${title%--*}

reportname=${title// /}

echo -e "\n"
echo -e "title:      $title"
echo -e "tabs:       $tabs"
echo -e "items:      $items"
echo -e "htmlout:    $htmlout"
echo -e "coverimage: $coverimage"
echo -e "gbtracks:   ${gbtracks[@]}"
echo -e "gbcount:   ${gbcount}"
echo -e "\n"

for i in $tabs
do 
	echo "tabname: $i" 
done



#if no coverimage provided, use default EMC logo
if [[ $coverimage == "-" ]] 
then
	cp $repositorypath/intro.jpg ${galaxypath}/intro.jpg
	coverimage="intro.jpg" 
else
	coverimage=${coverimage:1}
	echo -n "$coverimage" > tmpfileb64
	coverimage=`base64 -d tmpfileb64`
fi

## Copy supporting files from repository to output directory
cp ${repositorypath}/jquery.dataTables.css ${galaxypath}/jquery.dataTables.css
cp ${repositorypath}/jquery.dataTables.js ${galaxypath}/jquery.dataTables.js
cp -R ${repositorypath}/iframe-resizer/ ${galaxypath}/iframe-resizer/ > /dev/null 2>&1
cp -R ${repositorypath}/DataTables-1.9.4/ ${galaxypath}/DataTables-1.9.4/ > /dev/null 2>&1
cp ${repositorypath}/jquery.zoom.js ${galaxypath}/jquery.zoom.js
cp ${repositorypath}/jquery-ui.css ${galaxypath}/jquery-ui.css
cp ${repositorypath}/jquery-1.10.2.js ${galaxypath}/jquery-1.10.2.js
cp ${repositorypath}/jquery-ui.js ${galaxypath}/jquery-ui.js
cp ${repositorypath}/md.css ${galaxypath}/md.css
cp ${repositorypath}/ireport_css.css ${galaxypath}/ireport_css.css
cp ${repositorypath}/ireport_jquery.js ${galaxypath}/ireport_jquery.js

echo "done copying resource files"
ls ${galaxypath}


## Create cover HTML page
makeIntroPage "$title" $coverimage "report.html" $htmlout iReport_${reportname}.zip

## Create copy of cover page for downloadable version
makeIntroPage "$title" $coverimage "report.html" coverpage.html iReport_${reportname}.zip
cp coverpage.html ${galaxypath}/coverpage.html

## Create Report page with tabs
createMainPage ${galaxypath}/report.html "$tabs" "$items" $minwidth "$gbtracks"


## Create zip file of this iReport for download by user
wd=`pwd`
cd ${galaxypath}
zip -r iReport_${reportname} . > /dev/null 2>&1
cd $wd

wait