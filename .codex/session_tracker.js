#!/usr/bin/env node
// Session task logging for Codex CLI sessions (Node version)
// Records tasks to .codex/SESSION_TASKS.md and provides lookup on restart.
import fs from 'fs';
import path from 'path';

// Directory and tasks file path relative to working directory
const CODEX_DIR = path.resolve(process.cwd(), '.codex');
const TASKS_FILE = path.join(CODEX_DIR, 'SESSION_TASKS.md');

/**
 * Append a new task description with UTC timestamp
 * @param {string} description - full task text
 */
export function logTask(description) {
  try {
    fs.mkdirSync(CODEX_DIR, { recursive: true });
  } catch {
    // ignore
  }
  const timestamp = new Date().toISOString();
  const line = `${timestamp}  ${description.trim()}\n`;
  fs.appendFileSync(TASKS_FILE, line);
}

/**
 * Retrieve the last logged task entry, or null if none
 * @returns {string|null} raw line from the tasks file
 */
export function lastTask() {
  try {
    const data = fs.readFileSync(TASKS_FILE, 'utf8');
    const lines = data.split(/\r?\n/).filter(l => l.trim());
    return lines.length > 0 ? lines[lines.length - 1] : null;
  } catch {
    return null;
  }
}