const assert = require('node:assert/strict');
const test = require('node:test');
const { spawn } = require('node:child_process');

const port = 4100;

function waitForHealth() {
  return new Promise((resolve, reject) => {
    const deadline = Date.now() + 5000;
    const check = async () => {
      try {
        const response = await fetch(`http://127.0.0.1:${port}/api/health`);
        resolve(response);
      } catch (error) {
        if (Date.now() >= deadline) reject(error);
        else setTimeout(check, 100);
      }
    };
    check();
  });
}

test('GET /api/health returns service status', async () => {
  const server = spawn(process.execPath, ['src/server.js'], {
    cwd: __dirname + '/..',
    env: { ...process.env, PORT: String(port), DATABASE_URL: 'postgresql://invalid/unused' },
    stdio: ['ignore', 'ignore', 'ignore'],
  });

  try {
    const response = await waitForHealth();
    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), {
      ok: true,
      service: 'shopverse-api',
      version: '4.0.0',
    });
  } finally {
    server.kill();
  }
});
