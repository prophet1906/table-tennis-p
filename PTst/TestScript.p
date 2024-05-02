test tcTestGame [main=TestGame]:
  assert PlayerSafety, RefereeSafety in
  (union Player, Referee, { TestGame });