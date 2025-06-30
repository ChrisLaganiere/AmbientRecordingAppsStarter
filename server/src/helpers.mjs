/**
 * helpers.mjs
 * Reusable helper methods
 */

import crypto from "crypto";

/// Build a unique identifier for an entity
export function buildUUID() {
	return crypto.randomBytes(16).toString("hex");
}
