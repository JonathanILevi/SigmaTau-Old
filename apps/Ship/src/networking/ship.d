/**
An callback interface for the ship for networking.
*/

module networking.ship;

import console;

import console_network.message;

interface Ship {
	void on_consoleConnected	(Console console);
	void on_consoleDisconnected	(Console console);
		
	void on_getComponents	(Cts.OtherMsg.GetComponents msg, Console sender);
}

