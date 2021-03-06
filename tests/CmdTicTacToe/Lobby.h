#pragma once

#include "CMatchManager.h"
#include "ClanUtils.h"
#include <vector>

using std::vector;
using namespace CotCHelpers;
struct Tokenizer;

struct Lobby: CRefClass {
	struct RunResult {
		autoref<CMatch> match;
		shared_ptr<CHJSON> matchConfig;
	};
	struct Command {
		const char *name, *helpText, *syntax;
		function<void (Tokenizer&)> func;
		Command(const char *name, const char *helpText, function<void (Tokenizer&)> func)
			: name(name), helpText(helpText), syntax(""), func(func) {}
		Command(const char *name, const char *helpText, const char *syntax, function<void (Tokenizer&)> func)
			: name(name), helpText(helpText), syntax(syntax), func(func) {}
	};
	vector<Command> commands;

	Lobby();
	~Lobby() {}

	RunResult Run();

private:
	volatile bool commandPending;
	bool running, verbose;
	owned_ref<CHJSON> storedUsers, storedMatches;
	RunResult result;

	void AddUser(const char *gamerId, const char *secret);
	void CommandDone();
	const char *GetStoredMatch(Tokenizer &cmd);
	void PrintResult(const char *cmdName, const CCloudResult *result);
	void RunCommand(const char *cmd);
	void StartGame(CMatch *match, const CCloudResult *matchData);
};

