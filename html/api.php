<?php
# Copyright (c) 2019, PhysK
# All rights reserved.
include("tail.php");
include("datetime.php");
foreach (new DirectoryIterator("/config/json/") as $json) {
    if ($json->isFile() && !$json->isDot()) {
        $file = json_decode(file_get_contents("/config/json/".$json->getFileName()));
        if($file->filebase == null) { continue; }
        $jsonArray[$file->status][$file->filebase] = array(
                                                        "GDSA"=>$file->gdsa,
                                                        "filedir"=>$file->filedir,
                                                        "filebase"=>$file->filebase,
                                                        "filesize"=>$file->filesize
                                                    );
        if($file->status == "uploading") {
            $log = tailCustom($file->logfile, 6);
            preg_match("/([0-9\%]+) \/\d+\.\d+\w\, (\d+.\d+\w+\/s)\, ([0-9dhms]+)/", $log, $matches);
            if($matches)
            {
                $jsonArray[$file->status][$file->filebase]["upload"] = array("percent"=> $matches[1], "rate"=>$matches[2], "time"=>$matches[3]); 
            }
            else {
                $jsonArray[$file->status][$file->filebase]["upload"] = array("percent"=>"100%", "rate"=>"0MB/s", "time"=>"0s");
            }
        }
        if($file->status == "done") {
            $timestart = $file->starttime;
            $timeend = $file->endtime;
            $res = $timeend - $timestart;
            $timeobj = secondsToTime($res);
            $timetaken = "";
            if($timeobj["d"] > 0){
                $timetaken .= $timeobj["d"] . "d";
            }
            if($timeobj["h"] > 0){
                $timetaken .= $timeobj["h"] . "h";
            }
            if($timeobj["m"] > 0){
                $timetaken .= $timeobj["m"] . "m";
            }
            if($timeobj["s"] > 0){
                $timetaken .= $timeobj["s"] . "s";
            }
            $jsonArray[$file->status][$file->filebase]["timetaken"] = $timetaken;
        }
                                                    
    }
}
if(!isset($jsonArray["moving"]))
{
    $jsonArray["moving"] = null;
}
if(!isset($jsonArray["uploading"]))
{
    $jsonArray["uploading"] = null;
}
if(!isset($jsonArray["vfs"]))
{
    $jsonArray["vfs"] = null;
}
if(!isset($jsonArray["done"]))
{
    $jsonArray["done"] = null;
}
echo json_encode($jsonArray);