const test = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const { version } = require('../package.json');

const app = require('../src/server');

function request(path) {
  return new Promise((resolve, reject) => {
    const server = app.listen(0, '127.0.0.1', () => {
      const { port } = server.address();
      const req = http.get({ hostname: '127.0.0.1', port, path }, (res) => {
        let body = '';
        res.setEncoding('utf8');
        res.on('data', (chunk) => { body += chunk; });
        res.on('end', () => {
          server.close();
          resolve({ statusCode: res.statusCode, body: JSON.parse(body) });
        });
      });
      req.on('error', (error) => {
        server.close();
        reject(error);
      });
    });
    server.on('error', reject);
  });
}

test('GET /api/health reports the package version', async () => {
  const response = await request('/api/health');

  assert.equal(response.statusCode, 200);
  assert.deepEqual(response.body, {
    ok: true,
    service: 'shopverse-api',
    version
  });
});
