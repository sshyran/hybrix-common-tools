const basex = require('./base-x.js');

// replace multiple strings
// example: replacebulk("testme",['es','me'],['1','2']); => "t1t2"
function replaceBulk (str, findArray, replaceArray) {
  let i; let regex = []; let map = {};
  for (i = 0; i < findArray.length; i++) {
    regex.push(findArray[i].replace(/([-[\]{}()*+?.\\^$|#,])/g, '\\$1'));
    map[findArray[i]] = replaceArray[i];
  }
  regex = regex.join('|');
  str = str.replace(new RegExp(regex, 'g'), function (matched) {
    return map[matched];
  });
  return str;
}

function generateAsciiTable () {
  let x = '';
  for (let i = 0; i < 255; i++) { x = x + String.fromCharCode(i); }
  return x;
}
const asciiTable = generateAsciiTable();

function recode (source, target, input) {
  let BASE = function (val) {
    let out;
    switch (val) {
      case 2: out = '01'; break;
      case 8: out = '01234567'; break;
      case 10: out = '0123456789'; break;
      case 16: out = '0123456789abcdef'; break;
      case 58: out = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'; break;
      case 256: out = asciiTable; break;
      case 'RFC4648': out = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; break;
    }
    return out;
  };
  if (typeof target === 'undefined') { target = source; source = BASE(256); }
  switch (source) {
    case 'ascii':
      source = BASE(256);
      break;
    case 'base256':
      source = BASE(256);
      break;
    case 'base58':
      input = input.replace(/[^1-9A-HJ-NP-Za-km-z]/g, '');
      source = BASE(58);
      break;
    case 'hex':
      source = BASE(16);
      if (input.substring(0, 2) === '0x') { input = input.substring(2); }
      input = input.toLowerCase().replace(/[^0-9a-f]/g, '');
      break;
    case 'dec':
      input = (typeof input === 'number') ? String(input) : input.replace(/[^0-9]/g, '');
      source = BASE(10);
      break;
    case 'oct':
      input = input.replace(/[^0-7]/g, '');
      source = BASE(8);
      break;
    case 'bin':
      input = input.replace(/[^0-1]/g, '');
      source = BASE(2);
      break;
    default:
      if (source === 'string' || source === 'utf-8') { source = 'string'; }
      if (source === 'bech32' || source === 'RFC4648') {
        input = replaceBulk(input.toUpperCase(), ['0', '1', '8', '9'], ['O', 'I', 'B', 'G']).replace(/[^A-Z2-7]/g, '');
        source = BASE('RFC4648');
      }
      break;
  }
  switch (target) {
    case 'ascii': target = BASE(256); break;
    case 'base256': target = BASE(256); break;
    case 'base58': target = BASE(58); break;
    case 'hex': target = BASE(16); break;
    case 'dec': target = BASE(10); break;
    case 'oct': target = BASE(8); break;
    case 'bin': target = BASE(2); break;
    default:
      if (target === 'string' || target === 'utf-8' || target === 'utf8') { target = 'string'; }
      if (target === 'bech32' || target === 'RFC4648') { target = BASE('RFC4648'); }
      if (!target) { target = 'string'; }
      break;
  }
  const buffer = Buffer.from(source === 'string' ? input : basex(source).decode(input));
  let output;
  if (target === 'string') {
    output = Buffer.from(buffer.toString()).toString();
  } else {
    output = Buffer.from(basex(target).encode(buffer)).toString();
  }
  return output;
}

exports.recode = recode;
