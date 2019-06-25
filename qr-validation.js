function amountIsValid (s) {
  return isNumber(s);
}

function amountIsEmpty (s) {
  return s === '';
}

function addressIsValid (addr) {
  return isString(addr) && addr !== '';
}

function validateMessage (msg) {
  const isEmptyMessage = msg === '';

  return isString(msg) && !isEmptyMessage
    ? msg
    : null;
}

function hasValidTimestamp (s) {
  return isNumber(s);
}

function isNumber (s) {
  return !isNaN(Number(s));
}

function symbolIsValid (assetNames, symbol) {
  const symbols = Object.keys(assetNames);
  const isBitcoin = symbol === 'bitcoin';
  const symbolExists = symbols.includes(symbol) || isBitcoin;

  return symbolExists;
}

function isString (x) {
  return typeof x === 'string';
}

function validate (symbol, amount, addr, timestamp, assetNames) {
  const hasValidAmount = amountIsEmpty(amount) ? true : amountIsValid(amount);
  const hasValidTimestamp = timestamp !== null ? isNumber(timestamp) : true;

  return symbolIsValid(assetNames, symbol) &&
    hasValidAmount &&
    hasValidTimestamp &&
    addressIsValid(addr);
}

function parseToObject (s) {
  const symbol = getSymbol(s);
  const address = getAddress(s);
  const params = getParameters(s);
  const message = validateMessage(getMessage(s));

  return Object.assign({symbol, address, message}, params);
}

function getParameters (s) {
  const amount = getAmount(s);
  const timestamp = getTimestamp(s);

  return {
    amount,
    timestamp
  };
}

function getTimestamp (s) {
  const t_ = s.match(/until=(.*?)&/);
  const t = t_ === null ? s.match(/until=(.*)/) : t_;

  return t === null ? t : t.pop();
}

function getAmount (s) {
  const a_ = s.match(/amount=(.*?)&/);
  const a = a_ === null ? s.match(/amount=(.*)/) : a_;

  return a === null ? '' : a.pop();
}

function getMessage (s) {
  const msg = s.match(/message=(.*)/);
  return msg === null ? msg : msg.pop();
}

function getSymbol (s) {
  return s.match(/[^:]*/i)[0];
}

function getAddress (s) {
  const addr = s.match(/:(.*)\?/);
  return addr === null ? addr : addr.pop();
}

exports.validations = {
  hasValidTimestamp,
  parseToObject,
  validate
};

if (typeof module !== 'undefined') {
  module.exports = exports.validations;
}
