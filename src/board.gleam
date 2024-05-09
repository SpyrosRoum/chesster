import bitboard.{type Bitboard}

pub type Board {
  Board(
    pawns: Bitboard,
    knights: Bitboard,
    bishops: Bitboard,
    rooks: Bitboard,
    queens: Bitboard,
    kings: Bitboard,
    black: Bitboard,
    white: Bitboard,
  )
}

pub fn empty_board() -> Board {
  Board(
    pawns: bitboard.empty(),
    knights: bitboard.empty(),
    bishops: bitboard.empty(),
    rooks: bitboard.empty(),
    queens: bitboard.empty(),
    kings: bitboard.empty(),
    black: bitboard.empty(),
    white: bitboard.empty(),
  )
}
