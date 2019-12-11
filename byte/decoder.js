const baseCode = require('../basecode.js');

function validateInput (size, input) {
  if (isNaN(size)) {
    return `Expected parameter to be a number.`;
  } else if (input.length < size) {
    return `Input length insufficient.`;
  } else {
    return false;
  }
}

function decodeFixed (input, parameter, code) {
  const size = Number(parameter);
  const error = validateInput(size, input);
  if (error) {
    return [error];
  } else {
    let output = input.substr(0, size);
    output = baseCode.recode('bin', code, output);
    input = input.substring(size);
    return [0, input, output];
  }
}

function decodeIndexed (input, parameter, code) {
  const size = Number(parameter);
  const error = validateInput(size, input);
  if (error) {
    return [error];
  } else {
    const encodedLength = input.substr(0, size);
    input = input.substring(size);
    const length = Number(baseCode.recode('bin', 'dec', encodedLength));
    if (input.length < length) {
      return [`Input length insufficient.`];
    }
    let output = input.substr(0, length);
    output = baseCode.recode('bin', code, output);
    input = input.substring(length);
    return [0, input, output];
  }
}

function decodeDelimited (input, parameter, code) {
  const delimiter = parameter; // TODO check if delimiter is bin
  const index = input.indexOf(delimiter);
  let output;
  if (index === -1) {
    output = input;
    input = '';
  } else {
    output = input.substr(0, index - 1);
    input = input.substring(index + 1);
  }
  output = baseCode.recode('bin', code, output);
  return [0, input, output];
}

function decodeEnum (input, parameter, code) {
  const enums = parameter;
  if (!(enums instanceof Array)) {
    return [`Expected enums of type Array.`];
  }
  const enumSize = Math.ceil(Math.log(enums.length, 2));

  const encodedEnum = input.substr(0, enumSize);
  input = input.substring(enumSize);
  const index = Number(baseCode.recode('bin', 'dec', encodedEnum));
  if (index >= enums.length) {
    return [`Enum index out of range.`];
  }
  const output = enums[index];
  return [0, input, output];
}

exports.decodeFixed = decodeFixed;
exports.decodeIndexed = decodeIndexed;
exports.decodeDelimited = decodeDelimited;
exports.decodeEnum = decodeEnum;
