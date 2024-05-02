event eJoinGame: Referee;
event eServe: Player;
event eReceive: Player;

machine Player {
  var id: string;
  var referee: Referee;
  start state PlayerWaiting {
    entry (playerId: string) {
      id = playerId;
    }
    on eJoinGame do (gameReferee: Referee) {
      referee = gameReferee;
      goto PlayerReady;
    }
  }

  state PlayerReady {
    on eServe do (otherPlayer: Player) {
      if($) {
        send otherPlayer, eReceive, this;
      } else {
        send referee, eWinner, otherPlayer;
      }
    }

    on eReceive do (otherPlayer: Player) {
      if($) {
        send otherPlayer, eServe, this;
      } else {
        send referee, eWinner, otherPlayer;
      }
    }
  }
}