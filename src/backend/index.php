<?php

if ($_GET["exec"] == "true") {
        exec("./ping.sh");
}
else if ($_GET["puthosts"] == "true") {
        $hostlist = str_replace("@","\n",$_GET["hosts"]);
        $fp = fopen('hosts.txt', 'w');
        fwrite($fp, $hostlist);
        fwrite($fp, '23');
        fclose($fp);
}

?>