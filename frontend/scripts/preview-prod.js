#!/usr/bin/env node
/**
 * Cross-platform preview script for production
 * Handles PORT environment variable with fallback
 * Works on Windows, Linux, and macOS
 */
import { spawn } from 'child_process';

const port = process.env.PORT || '3000';
const host = '0.0.0.0';

console.log(`Starting Vite preview on ${host}:${port}`);

const vite = spawn('vite', ['preview', '--host', host, '--port', port], {
  stdio: 'inherit',
  shell: true
});

vite.on('error', (error) => {
  console.error('Failed to start Vite preview:', error);
  process.exit(1);
});

vite.on('exit', (code) => {
  process.exit(code || 0);
});

