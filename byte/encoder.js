const baseCode = require('../basecode.js');

function encodeFixed (output, input, parameter, code) {
  const size = Number(parameter);
  if (isNaN(size)) {
    return [`Expected size to be number.`];
  }
  if (output.length > size) {
    return [`Input length exceeds fixed size.`];
  }
  output = output.padStart(size, '0');
  return [0, input, output];
}

function encodeIndexed (output, input, parameter, code) {
  const size = Number(parameter);
  if (isNaN(size)) {
    return [`Expected type of size to be number, got ${typeof size}.`];
  }
  const length = output.length.toString();
  const encodedLength = baseCode.recode('dec', 'bin', length);
  if (encodedLength.length > size) {
    return [`Input length exceeds indexed size.`];
  }
  output = encodedLength.padStart(size, '0') + output;
  return [0, input, output];
}

function encodeDelimited (output, input, parameter, code) {
  // TODO check if delimiter is binary
  // TODO check if output does already not contain delimiter
  const delimiter = parameter;
  output += delimiter;
  return [0, input, output];
}

function encodeEnum (output, input, parameter, code) {
  const enums = parameter;
  if (!(parameter instanceof Array)) {
    return [`Expected enums of type Array.`];
  }
  const index = enums.indexOf(input);
  if (index === -1) {
    return [`Value ${input} not found in enum list ${enums}.`];
  }
  const encodedEnum = baseCode.recode('dec', 'bin', index);
  const enumSize = Math.ceil(Math.log(enums.length, 2));
  output = encodedEnum.padStart(enumSize, '0');
  return [0, input, output];
}

function encodeInteger (output, input, parameter, code) {
  if(isNaN(input) || (typeof input !== 'string' && typeof input !=='number' )) {
    return [`Expected bignum of type Number or String containing a number.`];
  }
  if (input.length>80) {
    return [`Expected bignum of size smaller or equal to 80.`];
  }
  const maxIdxBits = parameter||8;
  let numdata = String(input).replace(/[0]+$/,'');
  let numsize = String(input).length-numdata.length;
  if(numsize>9) { numdata = numdata.padEnd(String(input).length-9, '0'); numsize=9; }
  const encodedBignum = baseCode.recode('dec','bin', numdata.concat(numsize) );  
  const size = encodedBignum.length;
  const idxBits = baseCode.recode('dec','bin', size).padStart(maxIdxBits, '0');
  output = idxBits.concat(encodedBignum);
  return [0, input, output];
}

exports.encodeFixed = encodeFixed;
exports.encodeIndexed = encodeIndexed;
exports.encodeDelimited = encodeDelimited;
exports.encodeEnum = encodeEnum;
exports.encodeInteger = encodeInteger;
