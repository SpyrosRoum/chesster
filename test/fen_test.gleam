import gleeunit
import gleeunit/should

import board
import fen
import game

const starting_board = board.Board(
  pawns: 71_776_119_061_282_560,
  knights: 4_755_801_206_503_243_842,
  bishops: 2_594_073_385_365_405_732,
  rooks: 9_295_429_630_892_703_873,
  queens: 1_152_921_504_606_846_992,
  kings: 576_460_752_303_423_496,
  black: 18_446_462_598_732_840_960,
  white: 65_535,
)

pub fn main() {
  gleeunit.main()
}

pub fn parse_starting_pos_test() {
  fen.parse_fen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
  |> should.be_ok
  |> should.equal(game.Game(board: starting_board))
}

pub fn last_row_ends_early_test() {
  let expected_board =
    board.Board(
      pawns: 71_776_119_061_282_560,
      knights: 4_755_801_206_503_243_840,
      bishops: 2_594_073_385_365_405_732,
      rooks: 9_295_429_630_892_703_872,
      queens: 1_152_921_504_606_846_992,
      kings: 576_460_752_303_423_496,
      black: 18_446_462_598_732_840_960,
      white: 65_532,
    )

  fen.parse_fen("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKB2 w Qkq - 0 1")
  |> should.be_ok
  |> should.equal(game.Game(board: expected_board))
}

pub fn missing_pawns_test() {
  let expected_board =
    board.Board(
      pawns: 70_931_694_131_150_592,
      knights: 4_755_801_206_503_243_842,
      bishops: 2_594_073_385_365_405_732,
      rooks: 9_295_429_630_892_703_873,
      queens: 1_152_921_504_606_846_992,
      kings: 576_460_752_303_423_496,
      black: 18_445_618_173_802_708_992,
      white: 65_535,
    )

  fen.parse_fen("rnbqkbnr/pppppp2/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
  |> should.be_ok
  |> should.equal(game.Game(board: expected_board))
}

pub fn random_position_test() {
  let expected_board =
    board.Board(
      pawns: 65_319_804_248_059_392,
      knights: 4_611_690_416_476_258_304,
      bishops: 2_594_073_385_365_405_732,
      rooks: 9_295_429_639_482_638_464,
      queens: 35_184_372_088_848,
      kings: 576_460_752_303_423_496,
      black: 17_143_009_173_370_306_560,
      white: 8_877_567_676,
    )

  fen.parse_fen(
    "rnb1kb1r/ppp1p3/2qp1n2/5pR1/3P3P/2N2N2/PPP1PPP1/R1BQKB2 w HQkq - 0 1",
  )
  |> should.be_ok
  |> should.equal(game.Game(board: expected_board))
}

pub fn line_starts_empty_test() {
  let expected_board =
    board.Board(
      pawns: 0,
      knights: 0,
      bishops: 0,
      rooks: 2_305_843_009_213_693_952,
      queens: 0,
      kings: 0,
      black: 2_305_843_009_213_693_952,
      white: 0,
    )

  fen.parse_fen("2r5/8/8/8/8/8/8/8 w - - 0 1")
  |> should.be_ok
  |> should.equal(game.Game(board: expected_board))
}
