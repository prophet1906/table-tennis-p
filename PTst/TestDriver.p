machine TestGame
{
  start state Init {
    entry {
      var players: set[Player];
      var referee: Referee;
      
      players += (new Player("Player 1"));
      players += (new Player("Player 2"));

      referee = new Referee(players);
    }
  }
}