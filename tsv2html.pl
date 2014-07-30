print <<END;
<!DOCTYPE HTML>
<html>
<head>
<script src=\"jquery-1.10.2.js\"></script>
<script src=\"jquery-ui.js\"></script>
<script type="text/javascript" src="jquery.dataTables.js"></script>
<script type="text/javascript" src="iframe-resizer/js/iframeResizer.contentWindow.min.js"></script> 
<script>

    <!-- data tables -->
		\$(document).ready(function() {
    		\$('#datatable').dataTable( {
    			"bPaginate": true,
        		"bLengthChange": true,
        		"bFilter": true,
        		"bSort": true,
        		"bInfo": true,
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
    if($first == 1){
      print "<td>  $cell </td>";
      $first=0;
    }
	elsif($cell =~ /^(\d|\s)+$/) {
	    print "<td align=\"right\">$cell</td>"; }
	else {
	    print "<td>$cell</td>"; } }
    print "</tr>\n"; }
#print "</tr>\n</tbody>\n</table></body></html>\n";
print "</tbody>\n</table></body></html>\n";

