event eStartRound: Player;
event eWinner: Player;

machine Referee {
  var players: set[Player];
  var scoreBoard: map[Player, int];
  var startingPlayer: Player;
  start state StartGame {
    entry (participatingPlayers: set[Player]) {
      var p: Player;
      players = participatingPlayers;
      foreach (p in players)
      {
        send p, eJoinGame, this;
        scoreBoard[p] = 0;
        players += (p);
      };
      startingPlayer = choose(players);
      goto InstructPlayer;
    }
  }

  state InstructPlayer {
    entry {
      send this, eStartRound, startingPlayer;
    }

    on eStartRound do (startingPlayer: Player) {
      var otherPlayer: Player;
      otherPlayer = getOtherPlayer(startingPlayer);
      send startingPlayer, eServe, otherPlayer;
      goto WaitForRoundEnd;
    }

  }

  state WaitForRoundEnd {
    on eWinner do (winner: Player) {
      scoreBoard[winner] = scoreBoard[winner] + 1;
      if(scoreBoard[winner] == 10) {
        goto GameOver;
      } else {
        startingPlayer = winner;
        goto InstructPlayer;
      }
    }
  }

  state GameOver {
    entry {
      print format (
        "{0} scored {1}, {2} scored {3}", 
        players[0], 
        scoreBoard[players[0]], 
        players[1], 
        scoreBoard[players[1]]
      );
    }
  }

  fun getOtherPlayer(p: Player): Player {
    var player: Player;
    var otherPlayer: Player;
    foreach (player in players)
    {
      if (player != p)
      {
        otherPlayer = player;
      }
    };
    return otherPlayer;
  }
}