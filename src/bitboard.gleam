import gleam/int

pub type Bitboard =
  Int

pub fn empty() -> Bitboard {
  0
}

pub fn or(lhs: Bitboard, rhs: Bitboard) -> Bitboard {
  int.bitwise_or(lhs, rhs)
}
