import gleam/bool
import gleam/int
import gleam/iterator
import gleam/result
import gleam/string

import bitboard.{type Bitboard}
import board.{type Board}
import game.{type Game}

pub fn parse_fen(fen: String) -> Result(Game, String) {
  let parts = string.split(fen, " ")
  case parts {
    [pieces_part, _side_to_move, _castling, _en_passant, _halfmove, _fullmove] -> {
      use board <- result.try(parse_board(pieces_part, 1, board.empty_board()))

      Ok(game.Game(board: board))
    }
    _ -> Error("Bad FEN with missing parts")
  }
}

/// Parse the pieces part of a FEN, returning the Board repr
fn parse_board(
  board_part: String,
  pos: Int,
  board: Board,
) -> Result(Board, String) {
  case string.pop_grapheme(board_part) {
    Error(Nil) -> {
      case pos {
        x if x == 65 -> Ok(board)
        _ -> {
          Error("FEN ends early")
        }
      }
    }

    Ok(#(first, rest)) -> {
      case first {
        "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" -> {
          let amount = result.unwrap(int.parse(first), -1)
          parse_board(rest, pos + amount, board)
        }
        "/" -> parse_board(rest, pos, board)
        piece -> {
          use new_board <- result.try(parse_piece(piece, pos, board))
          parse_board(rest, pos + 1, new_board)
        }
      }
    }
  }
}

fn calc_bitboards_for_piece(
  piece_bitboard: Bitboard,
  color_bitboard: Bitboard,
  pos: Int,
) {
  let piece = int.bitwise_shift_left(1, 64 - pos)

  let new_piece = bitboard.or(piece_bitboard, piece)
  let new_color = bitboard.or(color_bitboard, piece)

  #(new_piece, new_color)
}

fn parse_piece(piece: String, pos: Int, board: Board) -> Result(Board, String) {
  case piece {
    // white
    "P" -> {
      let #(new_pawns, new_white) =
        calc_bitboards_for_piece(board.pawns, board.white, pos)
      let new_board = board.Board(..board, pawns: new_pawns, white: new_white)
      Ok(new_board)
    }
    "R" -> {
      let #(new_rooks, new_white) =
        calc_bitboards_for_piece(board.rooks, board.white, pos)
      let new_board = board.Board(..board, rooks: new_rooks, white: new_white)
      Ok(new_board)
    }
    "N" -> {
      let #(new_knights, new_white) =
        calc_bitboards_for_piece(board.knights, board.white, pos)
      let new_board =
        board.Board(..board, knights: new_knights, white: new_white)
      Ok(new_board)
    }
    "B" -> {
      let #(new_bishops, new_white) =
        calc_bitboards_for_piece(board.bishops, board.white, pos)
      let new_board =
        board.Board(..board, bishops: new_bishops, white: new_white)
      Ok(new_board)
    }
    "Q" -> {
      let #(new_queens, new_white) =
        calc_bitboards_for_piece(board.queens, board.white, pos)
      let new_board = board.Board(..board, queens: new_queens, white: new_white)
      Ok(new_board)
    }
    "K" -> {
      let #(new_kings, new_white) =
        calc_bitboards_for_piece(board.kings, board.white, pos)
      let new_board = board.Board(..board, kings: new_kings, white: new_white)
      Ok(new_board)
    }
    // black
    "p" -> {
      let #(new_pawns, new_black) =
        calc_bitboards_for_piece(board.pawns, board.black, pos)
      let new_board = board.Board(..board, pawns: new_pawns, black: new_black)
      Ok(new_board)
    }
    "r" -> {
      let #(new_rooks, new_black) =
        calc_bitboards_for_piece(board.rooks, board.black, pos)
      let new_board = board.Board(..board, rooks: new_rooks, black: new_black)
      Ok(new_board)
    }
    "n" -> {
      let #(new_knights, new_black) =
        calc_bitboards_for_piece(board.knights, board.black, pos)
      let new_board =
        board.Board(..board, knights: new_knights, black: new_black)
      Ok(new_board)
    }
    "b" -> {
      let #(new_bishops, new_black) =
        calc_bitboards_for_piece(board.bishops, board.black, pos)
      let new_board =
        board.Board(..board, bishops: new_bishops, black: new_black)
      Ok(new_board)
    }
    "q" -> {
      let #(new_queens, new_black) =
        calc_bitboards_for_piece(board.queens, board.black, pos)
      let new_board = board.Board(..board, queens: new_queens, black: new_black)
      Ok(new_board)
    }
    "k" -> {
      let #(new_kings, new_black) =
        calc_bitboards_for_piece(board.kings, board.black, pos)
      let new_board = board.Board(..board, kings: new_kings, black: new_black)
      Ok(new_board)
    }
    other -> Error("Unexpected piece: " <> other)
  }
}
