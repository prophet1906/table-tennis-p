spec PlayerSafety observes eJoinGame, eServe, eReceive {
  var joinedPlayerCount: int;
  var serveCount: int;
  var receiveCount: int;
  start state Waiting {
    on eJoinGame do {
      joinedPlayerCount = joinedPlayerCount + 1;
      if(joinedPlayerCount == 2) {
        goto Playing;
      }
    }
  }

  cold state Playing {
    on eServe do {
      serveCount = serveCount + 1;
    }
    on eReceive do {
      receiveCount = receiveCount + 1;
      if(serveCount < receiveCount) {
        print format("Received more times then served");
        goto InvalidState;
      }
    }
    on eWinner goto GameOver;
  }

  hot state GameOver {

  }

  hot state InvalidState {

  }
}

spec RefereeSafety observes eJoinGame, eStartRound, eWinner {
  var joinedPlayerCount: int;
  var scoreBoard: map[Player, int];
  start state WaitForPlayers {
    on eJoinGame do {
      joinedPlayerCount = joinedPlayerCount + 1;
      if(joinedPlayerCount == 2) {
        goto InstructPlayersToServe;
      }
    }
  }

  cold state InstructPlayersToServe {
    on eStartRound do {
      goto WaitForWinner;
    }
  }

  hot state WaitForWinner {
    on eWinner do (winner: Player) {
      if(winner in scoreBoard) {
        scoreBoard[winner] = scoreBoard[winner] + 1;
      } else {
        scoreBoard[winner] = 1;
      }
      if(scoreBoard[winner] == 10) {
        goto GameOver;
      } else {
        goto InstructPlayersToServe;
      }
    }
  }

  state GameOver {

  }
}