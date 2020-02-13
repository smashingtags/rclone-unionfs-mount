// Copyright (c) 2019, PhysK
// All rights reserved.
$(document).ready(function() {
    function update() {
        $.getJSON("api.php", function(json){
                var data = [];
                data["data"] = [];
                data["moving"] = [];
                data["uploading"] = [];
                data["vfs"] = [];
                data["done"] = [];
                var totalDatarate = 0;
                $.each( json, function( status, statusArray ) {
                    switch(status) {
                        case "uploading":
                            if(statusArray !== null)
                            {
                                $.each( statusArray, function( file, array ) {
                                    data["uploading"].push( "<tr>" );
                                    data["uploading"].push( "  <th>" + array["filebase"] + "</th>" );
                                    data["uploading"].push( "  <td>" + array["GDSA"] + "</td>" );
                                    data["uploading"].push( "  <td><div class=\"progress\"><div class=\"progress-bar progress-bar-striped progress-bar-animated bg-success\" role=\"progressbar\" aria-valuenow=\"" + array.upload["percent"] + "\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: " + array.upload["percent"] + "\">" + array.upload["percent"] + "</div></div></td>" );
                                    data["uploading"].push( "  <td>" + array["filesize"] + "</td>");
                                    rexex = /([0-9+\.]+)([MK])/
                                    var matches = array.upload["rate"].match(rexex);
                                    totalDatarate = Number(totalDatarate) + Number(matches[1]);
                                    var speed = Math.floor(matches[1])
                                    if(matches[2] == "M")
                                    {
                                        if(speed >= 70)
                                        {
                                            data["uploading"].push( "  <td>" + array.upload["rate"] + " <i class=\"fas fa-fighter-jet\" style=\"color:green; float:right;\"></i></td>" );
                                        }
                                        else if(speed < 70 && speed >= 40) {
                                            data["uploading"].push( "  <td>" + array.upload["rate"] + " <i class=\"fas fa-truck\" style=\"color:yellow; float:right;\"></i></td>" );
                                        }
                                        else {
                                            data["uploading"].push( "  <td>" + array.upload["rate"] + " <i class=\"fas fa-dolly\" style=\"color:red; float:right;\"></i></td>" );
                                        }
                                    }
                                    else {
                                        data["uploading"].push( "  <td>" + array.upload["rate"] + " <i class=\"fas fa-dolly\" style=\"color:red; float:right;\"></i></td>" );
                                    }
                                    data["uploading"].push( "  <td>" + array.upload["time"] + "</td>" );
                                    data["uploading"].push( "</tr>" );
                                });
                            }
                            else {
                                data["uploading"].push( "<tr>" );
                                data["uploading"].push( "  <td class=\"text-muted\" colspan=\"6\">No entries found.</td>");
                                data["uploading"].push( "</tr>" );
                            }
                            break;
                        case "vfs":
                            if(statusArray !== null)
                            {
                                $.each( statusArray, function( file, array ) {
                                    data["vfs"].push( "<tr>" );
                                    data["vfs"].push( "  <td>" + array["filedir"] + array["filebase"] + "</td>" );
                                    data["vfs"].push( "</tr>" );
                                });

                            }
                            else {
                                data["vfs"].push( "<tr>" );
                                data["vfs"].push( "  <td class=\"text-muted\">No entries found.</td>");
                                data["vfs"].push( "</tr>" );
                            }
                            break;
                        case "done":
                            if(statusArray !== null)
                            {
                                $.each( statusArray, function( file, array ) {
                                    data["done"].push( "<tr>" );
                                    data["done"].push( "  <td>" + array["filedir"] + "/" + array["filebase"] +"</td>" );
                                    data["done"].push( "  <td>" + array["filesize"] + "</td>");
                                    data["done"].push( "  <td>" + array["GDSA"] + "</td>" );
                                    data["done"].push( "  <td>" + array["timetaken"] + "</td>" );
                                    data["done"].push( "</tr>" );
                                });
                            }
                            else {
                                data["done"].push( "<tr>" );
                                data["done"].push( "  <td class=\"text-muted\" colspan=\"4\">No entries found.</td>");
                                data["done"].push( "</tr>" );
                            }
                            break;
                    }
                });
                for (var i in data)
                {
                    var bodyContent = data[i].join( "\n" );
                    var $table = $('#' + i);
                    $table.find('tbody').empty().append(bodyContent);
                }
                $('#datarate').find('span').text( totalDatarate.toFixed(2) );
        });
    }
    update();
    setInterval(update, 1000);
    console.log("Running");
});
