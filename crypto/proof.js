let DJB2 = require('./hashDJB2');

const TASK_GRANULARITY = 250;
const DEFAULT_DIFFICULTY = 50000;
const CONSTANT_A = 'w1iV++8Paiz1W/JPPasdRTiHiPaZkF3L5fQBpl/EsMsAAAA=';
const CONSTANT_B = 'braNzUosoR/WGHdjuE3vgOzS3vAm0yeHdryKUKfqMzOZrnnxM2j0ZBtosjbG+BpuoONa0SSg0g1a';
const CONSTANT_C = 'H4sIALBvLloCA02OMQ4CMQwEe16xD0B8gIqKhk9YspOzyMUo8d2J35OYAgoX691Z+1YZtjkswRdB';
const CONSTANT_D = 'rFGlQjLECtkQ7Lt2mCc+NCV4wbqX9VJehLZIsQGVN91vP+SUxmyOAAAA';
const CONSTANT_E = 'y37v4RNP7wiH+kEdyYTTp/alYktUHe0gsATc9IuVhmeS4eX2/5zs4XTQ';
const CONSTANT_F = 'H4sIAHBsLloCAy2M0Q3CQAxD/5nCA1SMAQMwwVUXLpHSBF3SVmxPKvFn';
const CONSTANT_G = 'PowerToThePeople_';

function createHash (prfx, pow) {
  return prfx + DJB2.hash(String(CONSTANT_D + String(pow) + prfx + CONSTANT_E + String(pow).split('').reverse().join('') + CONSTANT_F));
}

function create (difficulty) {
  difficulty = (typeof difficulty === 'undefined' || isNaN(difficulty) ? DEFAULT_DIFFICULTY : difficulty);

  let pow = (1 + Math.random()) * difficulty; // Create a number between difficulty and 2 times difficulty

  pow = Math.floor(pow + (Math.floor(Math.random() * 5) * (difficulty / 5))); // pow is now a number between difficulty and 3 times difficulty

  let prfx = ''; // The prefix serves as a hint for the proof
  for (let i = 0; i < 5; i++) {
    prfx += DJB2.hash(CONSTANT_A + i + CONSTANT_B + String(Math.random() * (Math.random() * 1000000)) + CONSTANT_C);
  }
  return {hash: createHash(prfx, pow), proof: DJB2.hash(CONSTANT_G + String(pow))};
}

const executeTaskStep = (tasks, taskId, hint, difficulty, dataCallback, errorCallback, progressCallback) => () => {
  // this process has been tasked to scan a 1/TASK_GRANULARITY part of all possible solutions
  const task = tasks[taskId];
  const step = task.step;
  const maxSteps = Math.ceil(2 * difficulty / TASK_GRANULARITY); // the maximum nr of steps any process will handle

  if (taskId === 0 && typeof progressCallback === 'function') {
    progressCallback(step / (maxSteps + 1));
  }

  if (step < maxSteps) {
    const prfx = hint.substr(0, 8 * 5);
    const firstStep = difficulty + taskId * maxSteps;
    const pow = firstStep + step; // Create a number between difficulty and 3 times difficulty
    const hash = createHash(prfx, pow);
    if (hint === hash) { // The hash is found, work is done
      for (let k = 0; k < TASK_GRANULARITY; k++) { // clear all running processes
        if (tasks[k].interval !== null) {
          clearInterval(tasks[k].interval); // clear this process interval
        }
      }
      if (typeof dataCallback === 'function') { dataCallback(DJB2.hash(CONSTANT_G + String(pow))); }
    } else { // The hash is not yet found, next step
      ++task.step;
    }
  } else { // nr of steps exceeded. This process failed, check if all steps have failed
    let countFailed = 0;
    for (let k = 0; k < TASK_GRANULARITY; k++) {
      if (tasks[k].step >= maxSteps) {
        countFailed += 1;
      }
    }
    clearInterval(task.interval); // clear this process interval
    task.interval = null;
    if (countFailed === TASK_GRANULARITY) { // all processes have fails
      if (typeof errorCallback === 'function') { errorCallback('Proof of Work failed.'); }
    }
  }
};

function solve (hint, difficulty, dataCallback, errorCallback, progressCallback) {
  difficulty = (typeof difficulty === 'undefined' || isNaN(difficulty) ? DEFAULT_DIFFICULTY : difficulty);

  const tasks = [];

  for (let taskId = 0; taskId < TASK_GRANULARITY; taskId++) { // Subdivide the work into tasks
    tasks[taskId] = {
      step: 0,
      interval: setInterval(executeTaskStep(tasks, taskId, hint, difficulty, dataCallback, errorCallback, progressCallback), 1)
    };
  }
}

exports.create = create;
exports.solve = solve;
