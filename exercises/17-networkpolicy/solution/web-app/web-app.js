var mysql = require('mysql');
var http = require('http');

const hostname = '0.0.0.0';
const port = 3000;

const server = http.createServer((req, res) => {
  var con = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
  });

  con.connect(function(err) {
    if (err) {
        console.error(err);
        res.statusCode = 500;
        res.setHeader('Content-Type', 'text/plain');
        res.end('Failed to connect to database: ' + err.message);
    } else {
        console.log('Connected!');
        res.statusCode = 200;
        res.setHeader('Content-Type', 'text/plain');
        res.end('Successfully connected to database!');
    }
  });
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});