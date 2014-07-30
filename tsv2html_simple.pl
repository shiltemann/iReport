print <<END;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.js"></script>
<script type="text/javascript" src="jquery.dataTables.js"></script>
<script type="text/javascript" src="iframe-resizer/js/iframeResizer.contentWindow.min.js"></script> 
<script>

    <!-- data tables -->
		\$(document).ready(function() {
    		\$('#datatable').dataTable( {
    			"bPaginate": false,
        		"bLengthChange": false,
        		"bFilter": false,
        		"bSort": false,
        		"bInfo": false,
        		"bAutoWidth": true    		
    		} );
		} );
	<!-- data tables -->   
</script>

<link rel="stylesheet" type="text/css" href="jquery.dataTables.css">
</head>
<body>
<table class="display dataTable" id="datatable" border="1" cellspacing="0" cellpadding="0" style="font-size: 12px;" > 
<thead>
<tr><th>
END
chomp ($_ = <STDIN>);
s?\t?</th><th>?g;
print "$_</th></tr>\n";
#print "</tr>\n</thead>\n<tbody>\n";
print "</thead>\n<tbody>\n";
while (<>) {
    print "<tr>\n";
    my @fields = split('\t');
    my $first=1;
    for $cell(@fields) {
    if($cell =~ /^(\d|\s)+$/) {
    	1 while ($cell =~ s/^(-?\d+)(\d{3})/$1,$2/);
	    print "<td align=\"right\">$cell</td>";
	    #print "<td>$cell</td>"; 
	}
	else {
	    print "<td>$cell</td>"; } }
    print "</tr>\n"; }
#print "</tr>\n</tbody>\n</table></body></html>\n";
print "</tbody>\n</table></body></html>\n";

