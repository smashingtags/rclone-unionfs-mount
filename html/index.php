<!--
# Copyright (c) 2019, PhysK
# All rights reserved.
-->
<html>
<head>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
  <script src="app.js"></script>
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
  <title>Uploader Tracker</title>
</head>
<!-- UI BY Bryde ツ -->
<body>
    <div class="container-responsive jumbotron">
        <div class="row">
            <h1>Uploads</h1>
            <div class="table-responsive">
                <table id="uploading" class="table table-striped table-bordered table-hover table-dark">
                    <thead>
                        <tr>
                            <th>Filename</th>
                            <th>GDSA</th>
                            <th>Progress bar</th>
                            <th>Filesize</th>
                            <th>Speed <div style="float: right;" id="datarate"><span>0</span>M/s</div></th>
                            <th style="width:10%">Time Left</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-muted" colspan="6">No entries found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <h1>vfs waits</h1>
            <div class="table-responsive">
                <table id="vfs" class="table table-striped table-bordered table-hover table-dark">
                    <thead>
                        <tr>
                            <th>Filename</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-muted">No entries found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <h1>Completed</h1>
            <div class="table-responsive">
                <table id="done" class="table table-striped table-bordered table-hover table-dark">
                    <thead>
                        <tr>
                            <th>Filename</th>
                            <th>Filesize</th>
                            <th>GDSA</th>
                            <th>Time spent</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-muted" colspan="4">No entries found.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<!-- container -->
</body>
</html>