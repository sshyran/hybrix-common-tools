const fs = require('fs');
const file = process.argv[2];

// console.log(process.argv)
const content = fs.readFileSync(file).toString();

try {
  JSON.parse(content);
} catch (e) {
  console.log(e);
  process.exit(1);
}
