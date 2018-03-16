/**
An callback interface for the ship for networking.
*/

module networking.ship;

import console;

interface Ship {
	void on_consoleConnected	(Console console);
	void on_consoleDisconnected	(Console console);
}

