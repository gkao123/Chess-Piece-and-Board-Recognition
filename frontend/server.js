var express = require('express');
var app = express();
var path = require('path');
var formidable = require('formidable');
var fs = require('fs');
var spawn = require("child_process").spawn;

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', function(req, res){
  res.sendFile(path.join(__dirname, 'views/index.html'));
});

app.post('/upload', function(req, res){

  // create an incoming form object
  var form = new formidable.IncomingForm();

  // specify that we want to allow the user to upload multiple files in a single request
  form.multiples = true;

  // store all uploads in the /uploads directory
  form.uploadDir = path.join(__dirname, '/uploads');

  // every time a file has been uploaded successfully,
  // rename it to it's orignal name
  form.on('file', function(field, file) {
    fs.rename(file.path, path.join(form.uploadDir, file.name));
    var obj = {
      table: []
    };
    var fileName = path.join(form.uploadDir, file.name);
    obj.table.push({path: fileName})
    var command = " \"/usr/local/MATLAB/R2018a/bin/matlab\" -nodisplay -nosplash -nodesktop -r \"run(\'/home/g/Documents/COSI177/frontend/test.m\');exit;\""

    fs.writeFile ("imagePath.json", JSON.stringify(obj), function(err) {
      if (err) throw err;
      console.log('json file written');
    })
    const { exec } = require('child_process');
    exec(" \"/usr/local/MATLAB/R2018a/bin/matlab\" -nodisplay -nosplash -nodesktop -r \"run(\'/home/g/Documents/COSI177/frontend/test.m\');exit;\"" , (err, stdout, stderr) => {
      if (err) {
        // node couldn't execute the command
        console.log("error")
        return;
      }
    // the *entire* stdout and stderr (buffered)
    console.log(`stdout: ${stdout}`);
    console.log(`stderr: ${stderr}`);
    });
  });

  // log any errors that occur
  form.on('error', function(err) {
    console.log('An error has occured: \n' + err);
  });

  // once all the files have been uploaded, send a response to the client
  form.on('end', function() {
    res.end('success');
  });

  // parse the incoming request containing the form data
  form.parse(req);

});
app.get('/results', function(req, res){
  res.sendFile(path.join(__dirname, 'views/results.html'));
});
var server = app.listen(3000, function(){
  console.log('Server listening on port 3000');
});
